import router from '@ohos.router'
import fs from '@ohos.file.fs'
import common from '@ohos.app.ability.common';
import picker from '@ohos.file.picker';
import request from '@ohos.request';
import { baseUrl } from '../api/BaseData';
import { editUserInfo } from '../api/UserApi';

//获取应用文件路径
let context = getContext(this) as common.UIAbilityContext;

@Entry
@Component
struct UserInfoPage {
  @State info: any = {};
  private uploadTask: request.UploadTask;
  @State isShow: boolean = false;
  @State imgDatas: string[] = [];
  @State resultMsg: string = '66666666666666'
  @State fileName: string = ''
  // 获取照片url集
  getAllImg() {
    try {
      let PhotoSelectOptions = new picker.PhotoSelectOptions();
      PhotoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      PhotoSelectOptions.maxSelectNumber = 1;
      let photoPicker = new picker.PhotoViewPicker();
      photoPicker.select(PhotoSelectOptions).then((PhotoSelectResult) => {
        this.imgDatas = PhotoSelectResult.photoUris;
        this.writeImage()
      }).catch((err) => {

      });
    } catch (err) {
    }
  }
  //写文件
  writeImage() {
    let URI = this.imgDatas[0]
    this.resultMsg = URI;
    console.info("==============", URI)
    let cacheDir = getContext(this).cacheDir
    let srcFile = fs.openSync(URI, fs.OpenMode.READ_ONLY);
    let destFile = fs.openSync(cacheDir + "/file.png", fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    // 读取源文件内容并写入至目的文件
    let bufSize = 4096;
    let readSize = 0;
    let buf = new ArrayBuffer(bufSize);
    let readLen = fs.readSync(srcFile.fd, buf, { offset: readSize });
    while (readLen > 0) {
      readSize += readLen;
      fs.writeSync(destFile.fd, buf);
      readLen = fs.readSync(srcFile.fd, buf, { offset: readSize });
    }
    console.info("=======2222=======", URI)
    // 关闭文件
    fs.closeSync(srcFile);
    fs.closeSync(destFile);
    this.uploadFile();
    console.info("=========3333=====", URI)
  }

  uploadFile() {
    let url = baseUrl + '/file/upload/avatar';
    //上传任务配置项
    let uploadConfig = {
      url: url,
      header: { Authorization: globalThis.token },
      method: 'POST',
      files: [
        { filename: '', name: 'file', uri: "internal://cache/file.png", type: 'image/png' }
      ],
      data: []
    }
    //将本地应用文件上传至网络服务器
    try {
      request.uploadFile(context, uploadConfig)
        .then((data) => {
          console.info("=============uploadFile1=======================")
          this.uploadTask = data
          this.uploadTask.on("headerReceive", (header) => {
            let str = JSON.stringify(header);
            let begin = str.indexOf("filename=") + "filename=".length;
            console.info("=============uploadFile3=======================", begin + "-----")
            let end = str.indexOf("\\r\\n", begin)
            console.info("=============uploadFile3=======================", end + "-----")
            let fileName = str.substring(begin, end);
            console.info("=============uploadFile3=======================", fileName)
            this.info.avatar = fileName
            editUserInfo(this.info).then((res) => {
              this.resultMsg = `${baseUrl}/file/${this.info.avatar}`
              globalThis.info = this.info
            })
          })

        })
        .catch((err) => {
          console.info("===============", `xxInvokeuploadFilefailed,codeis${err.code},messageis${err.message}`);
        })
    } catch (err) {
      console.info("===============", `xxInvokeuploadFilefailed,codeis${err.code},messageis${err.message}`);
    }
  }

  aboutToAppear() {
    this.info = globalThis.info
    this.resultMsg = `${baseUrl}/file/${this.info.avatar}`
  }

  onPageShow() {
    this.info = globalThis.info
    this.resultMsg = `${baseUrl}/file/${this.info.avatar}`
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Stack({ alignContent: Alignment.Start }) {
        Text('个人信息')
          .width('100%')
          .height(60)
          .fontSize(20)
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontColor(Color.Grey)
        Image($r('app.media.iv_back_selected')).width(40).height(40)
          .onClick(() => {
            router.back();
          }).margin({ left: 10 })
      }.height(60).width('100%').margin({ top: 10 })
      .zIndex(100)

      Column() {
        //基本信息
        List() {
          ListItem() {
            Row() {
              Text('头像:').width(100)
              Blank()
              Image(this.resultMsg).width(70).height(70).borderRadius(35)
                .margin({ right: 20 })
              Image($r('app.media.chevron_right')).width(16).height(16)
            }.width('100%')
          }.padding({ left: 20, right: 20 }).height(80)
          .onClick(() => {
            this.isShow = true;
          })

          ListItem() {
            Row() {
              Text('基本信息:').width(100)
              Blank()
              Image($r('app.media.chevron_right')).width(16).height(16)
            }.width('100%')
          }.padding({ left: 20, right: 20 }).height(80)
          .onClick(() => {
            router.pushUrl({ url: 'pages/info/EditInfoPage', params: { info: JSON.stringify(this.info) } })
          })

          ListItem() {
            Row() {
              Text('修改密码:').width(100)
              Blank()
              Image($r('app.media.chevron_right')).width(16).height(16)
            }.width('100%')
            .onClick(() => {
              router.pushUrl({ url: 'pages/info/UpdatePasswordPage', params: { info: JSON.stringify(this.info) } })
            })
          }.padding({ left: 20, right: 20 }).height(80)

        }.divider({ strokeWidth: 1, color: '#f1f1f1', startMargin: 20, endMargin: 20 }) // 每行之间的分界线
        .borderRadius(10)
        .margin(5)
        .backgroundColor('#ffffff')
      }
      .width('100%')
      .margin({ top: 70 })
      .layoutWeight(1)

      // Stack({alignContent:Alignment.BottomEnd}){
      //     Button('注销').fontColor(Color.White).backgroundColor(Color.Red)
      //       .fontSize(16)
      //       .type(ButtonType.Normal)
      //       .width('100%')
      //       .borderRadius(10)
      //       .height(40)
      //       .onClick(()=>{
      //         let filePath = globalThis.path ;
      //         fs.unlink(filePath).then(() => {
      //           globalThis.token=''
      //           router.pushUrl({url:'pages/Index'})
      //         }).catch((err) => {
      //           console.info("remove file failed with error message: " + err.message + ", error code: " + err.codeor);
      //         });
      //       })
      // }.width('100%')
      // .height('100%').zIndex(-1)
      Panel(this.isShow) {
        Column() {
          List() {
            // ListItem() {
            //   Row() {
            //     Text("拍摄")
            //   }.height(60).width('100%').justifyContent(FlexAlign.Center)
            // }

            ListItem() {
              Row() {
                Text("从手机相册选择")
              }.height(60).width('100%').justifyContent(FlexAlign.Center)
              .onClick(() => {
                this.getAllImg()
                this.isShow = false
              })
            }

            ListItem() {
              Row() {
                Text("取消")
              }.height(60).width('100%').justifyContent(FlexAlign.Center)
              .onClick(() => {
                this.isShow = false
              })
            }
          }
          .width('100%')
          .height('100%')
          .backgroundColor('#ffffff')
          .divider({ strokeWidth: 1, color: "#f1f1f1" }) // 每行之间的分界线
          .borderRadius(20)
        }
      }
      .type(PanelType.Foldable)
      .mode(PanelMode.Half)
      .fullHeight(120)
      .dragBar(false) // 默认开启
      .halfHeight(120) //
      .onChange((width: number, height: number, mode: PanelMode) => {
        console.info(`width:${width},height:${height},mode:${mode}`)
      })

    }
    .height('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }
}