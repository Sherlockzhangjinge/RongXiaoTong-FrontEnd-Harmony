import router from '@ohos.router'
import http from '@ohos.net.http';
import promptAction from '@ohos.promptAction';
import picker from '@ohos.file.picker';
import request from '@ohos.request';
import fs from '@ohos.file.fs'
import common from '@ohos.app.ability.common';
import hash from '@ohos.file.hash';
import { baseUrl } from '../api/BaseData';
import { addNeeds, editNeeds } from '../api/GoodsApi';

//获取应用文件路径
let context = getContext(this) as common.UIAbilityContext;

@Entry
@Component
struct ReleaseGoodsPage {
  @State headTitle:string = ''
  @State orderId:string = ''
  @State type: string = ''
  @State content: string = ''
  @State picture: string = ''
  @State title: string = ''
  @State price: string = ''
  @State isShow: boolean = false
  private uploadTask: request.UploadTask;
  @State resultMsg: string = ''
  ////
  @State imgDatas: string[] = [];
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
    // 关闭文件
    fs.closeSync(srcFile);
    fs.closeSync(destFile);
    this.uploadFile();
    //this.picture="7161ea47f95a49a0b3508201c9fe3098.jpg"

  }
  ///
  uploadFile() {
    let url = baseUrl + '/file/upload/order';
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
            this.resultMsg = fileName
            this.picture = fileName;
            console.info("=============uploadFile3=======================", fileName)
          })

        })
        .catch((err) => {
          console.info("===============", `xxInvokeuploadFilefailed,codeis${err.code},messageis${err.message}`);
        })
    } catch (err) {
      console.info("===============", `xxInvokeuploadFilefailed,codeis${err.code},messageis${err.message}`);
    }
  }
  //获取商品类型
  aboutToAppear() {
    this.type = router.getParams()['type'];
    if(this.type == 'addNeeds'||this.type == 'addGoods'){
      this.headTitle = '添加商品信息'
    }else{
      this.headTitle = '修改商品信息'
      let info = JSON.parse(router.getParams()['info'])
      console.log(info)
      this.orderId = info.orderId
      this.title = info.title
      this.price = info.price
      this.content = info.content
      this.imgDatas=[`${baseUrl}/file/${info.picture}`]
      this.picture = info.picture


    }
  }

  build() {
    Stack() {
      Column() {
        Stack({ alignContent: Alignment.Start }) {
          Text(this.headTitle)
            .width('100%')
            .height(60)
            .fontSize(20)
            .width('100%')
            .textAlign(TextAlign.Center)
            .fontColor(Color.Grey)

          Row() {
            Text('取消').onClick(() => {
              this.title = ''
              this.content = ''
              this.picture = ''
              this.price = ''
              this.isShow = false;
              this.imgDatas = []
            }).margin({ right: 10 })
          }.justifyContent(FlexAlign.End).width('100%')

          Image($r('app.media.iv_back_selected')).width(40).height(40)
            .onClick(() => {
              router.back();
            }).margin({ left: 10 })
        }.height(60).width('100%').margin({ top: 10 })

        Row() {
          Text("设置商品照片").fontSize(14).fontColor(Color.Gray)
        }.height(40).justifyContent(FlexAlign.Start).width('100%').padding({ left: 20, right: 20 })

        Column() {
          //基本信息
          List() {
            ListItem() {
              Row() {
                Text('照片:').width(40)

                if (this.imgDatas.length > 0) {
                  Image(this.imgDatas[0])
                    .width(150)
                    .height(150)
                    .borderRadius(10).margin({ left: 10 })
                }
                Column() {
                  Image($r('app.media.camera')).width(40).height(40)
                  Text('添加照片').fontSize(16)
                }
                .onClick(() => {
                  this.isShow = true;
                })
                .alignItems(HorizontalAlign.Center)
                .justifyContent(FlexAlign.Center)
                .width(150)
                .height(150)
                .borderRadius(10)
                .backgroundColor('#F1F3F5')
                .margin({ left: 10 })

              }
            }.padding({ left: 20, right: 20 }).height(180)
          }.divider({ strokeWidth: 1, color: '#f1f1f1', startMargin: 20, endMargin: 20 }) // 每行之间的分界线
          .borderRadius(10)
          .margin(5)
          .backgroundColor('#ffffff')


          Row() {
            Text("添加商品基本信息").fontSize(14).fontColor(Color.Gray)
          }.height(40).width('100%').justifyContent(FlexAlign.Start).padding({ left: 20, right: 20 })
          //基本信息
          List() {
            ListItem() {
              Row() {
                Text('标题:').width(40)
                TextInput({ placeholder: '添加商品标题', text: this.title }).onChange((val) => {
                  this.title = val
                }).borderWidth(0).backgroundColor(Color.Transparent)
              }
            }.padding({ left: 20, right: 20 }).height(60)

            ListItem() {
              Row() {
                Text('内容:').width(40)
                TextArea({ placeholder: '添加商品内容', text: this.content }).onChange((val) => {
                  this.content = val
                }).borderWidth(0).backgroundColor(Color.Transparent)
                  .height(100)
              }
            }.padding({ left: 20, right: 20 }).height(120)

            ListItem() {
              Row() {
                Text('定价:').width(40)
                TextInput({ placeholder: '商品价格', text: this.price }).onChange((val) => {
                  this.price = val
                }).borderWidth(0).backgroundColor(Color.Transparent)
              }
            }.padding({ left: 20, right: 20 }).height(60)
          }.divider({ strokeWidth: 1, color: '#f1f1f1', startMargin: 20, endMargin: 20 }) // 每行之间的分界线
          .borderRadius(10)
          .margin(5)
          .backgroundColor('#ffffff')

        }.layoutWeight(1)

        if (!this.isShow) {
          Row() {
            Button("保存")
              .fontColor(Color.White)
              .backgroundColor(Color.Red)
              .type(ButtonType.Normal)
              .width('100%')
              .borderRadius(20)
              .onClick(() => {
                if(this.type == 'addNeeds' ||this.type == 'addGoods'){
                  addNeeds({
                    picture:this.picture,
                    title:this.title,
                    content:this.content,
                    price:this.price,
                    type:this.type=='addNeeds'?'needs':'goods',
                  }).then((res)=>{
                    let rst = JSON.parse(res.result.toString());
                    if (rst.code == 20000) {
                      promptAction.showToast({
                        message: '添加成功!',
                        duration: 1000,
                      });
                      setTimeout(() => {
                        router.replaceUrl({ url: "pages/MyGoodsPage", params: { type: this.type=='addNeeds'?'needs':'goods' } });
                      }, 1000)
                    } else {
                      promptAction.showToast({
                        message: '添加失败!' + rst.data,
                        duration: 2000,
                      });
                    }
                  })
                } else if(this.type == 'editNeeds' || this.type =='editGoods'){
                  editNeeds({
                    orderId:this.orderId,
                    picture:this.picture,
                    title:this.title,
                    content:this.content,
                    price:this.price,
                    type:'needs',
                  }).then((res)=>{
                    let rst = JSON.parse(res.result.toString());
                    if (rst.code == 20000) {
                      promptAction.showToast({
                        message: '修改成功!',
                        duration: 1000,
                      });
                      setTimeout(() => {
                        router.replaceUrl({ url: "pages/MyGoodsPage", params: { type: this.type=='editNeeds'?'needs':'goods' } });
                      }, 1000)
                    } else {
                      promptAction.showToast({
                        message: '修改失败!' + rst.data,
                        duration: 2000,
                      });
                    }

                  })

                }
              })
          }.alignItems(VerticalAlign.Bottom).padding(10).backgroundColor('#ffffff')
          .width('100%')
        }
      }
      .width('100%')

      Panel(this.isShow) {
        Column() {
          List() {
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
    .height('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }
}