import router from '@ohos.router';
import picker from '@ohos.file.picker';

import request from '@ohos.request';
import fs from '@ohos.file.fs'
import common from '@ohos.app.ability.common';
import { baseUrl } from '../../api/BaseData';
import promptAction from '@ohos.promptAction';
import { addFinanceMulti } from '../../api/FinanceApi';

let context = getContext(this) as common.UIAbilityContext;

/**
 * 组合贷款
 */
@Preview
@Entry
@Component
struct PortfolioLoansPage {
  @State bank: any = {};
  @State uri: any = ''
  @State imgDatas: string[] = [];
  private uploadTask: request.UploadTask;
  @State resultMsg: string = '66666666666666'
  @State repayments: string[] = ["6", "12", "24", "36"];
  @State info:any={
    bankId:"",
    combinationIdnum1:"45678",
    combinationIdnum2:"7890",
    combinationName1:"王小明",
    combinationName2:"陈贝贝",
    combinationPhone1:"456",
    combinationPhone2:"789",
    fileInfo:"d5673315217c42608ea27c9c7dbc0f44.jpg",
    idNum:"12345",
    money:"55",
    phone:"123",
    rate:1.2,
    realName:"王可",
    repayment:6
  }

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
    console.info("==============", URI)
    let cacheDir = getContext(this).cacheDir
    let srcFile = fs.openSync(URI, fs.OpenMode.READ_WRITE);
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
  }

  uploadFile() {
    let url = baseUrl + '/file/uploadInfo/info';
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

  addFinanceMulti(){
    let info={
      bankId:this.bank.bankId,
      combinationIdnum1:this.info.combinationIdnum1,
      combinationIdnum2:this.info.combinationIdnum2,
      combinationName1:this.info.combinationName1,
      combinationName2:this.info.combinationName2,
      combinationPhone1:this.info.combinationPhone1,
      combinationPhone2:this.info.combinationPhone2,
      fileInfo:this.info.fileInfo,
      idNum:this.info.idNum,
      money:this.info.money,
      phone:this.info.phone,
      rate:this.bank.rate,
      realName:this.info.realName,
      repayment:this.info.repayment
    }
    addFinanceMulti(info).then(rst=>{
      console.info("===================",rst.result.toString())
      let data = JSON.parse(rst.result.toString());
      if (data.code == 20000) {
        promptAction.showToast({ message: '申请成功!', duration: 2000 })
      } else {
        promptAction.showToast({ message: '申请失败!', duration: 2000 })
      }
    })
  }
  aboutToAppear() {
    this.bank = router.getParams()["info"];
  }

  build() {
    Row() {
      Column() {
        Stack({ alignContent: Alignment.Start }) {
          Text('组合贷款信息')
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

        Column() {
          Row() {
            Text("申请融资信息:")
          }.width('100%').margin(10)

          List({ space: 10 }) {

            ListItem() {
              Row() {
                Text('融资额度:').width(90).textAlign(TextAlign.End).margin({ right: 10 })
                TextInput().width(250).borderRadius(5).onChange((val) => {
                  this.info.money=val
                })
              }
            }

            ListItem() {
              Row() {
                Text('利息:').width(90).textAlign(TextAlign.End).margin({ right: 10 })
                Text(this.bank.rate+'')
              }
            }

            ListItem() {
              Row() {
                Text('意向借款期:').width(90).textAlign(TextAlign.End).margin({ right: 10 })
                Select([{ value: '六个月' }, { value: '一年' }, { value: '二年' }, { value: '三年' }])
                  .value('请选择意向借款期')
                  .onSelect((index: number) => {
                    this.info.repayment = this.repayments[index];
                  })
                  .width(250)
                  .borderRadius(5)
              }
            }
          }

          Row() {
            Text("用户1:")
          }.width('100%').margin({top:10,bottom:10})

          List({ space: 10 }) {
            ListItem() {
              Row() {
                Text('姓名:').width(90).textAlign(TextAlign.End).margin({ right: 10 })
                TextInput().width(250).borderRadius(5).onChange((val) => {
                  this.info.realName=val
                })
              }
            }

            ListItem() {
              Row() {
                Text('联系方式:').width(90).textAlign(TextAlign.End).margin({ right: 10 })
                TextInput().width(250).borderRadius(5).onChange((val) => {
                  this.info.phone=val
                })
              }
            }

            ListItem() {
              Row() {
                Text('身份证号:').width(90).textAlign(TextAlign.End).margin({ right: 10 })
                TextInput().width(250).borderRadius(5).onChange((val) => {
                  this.info.idNum=val
                })
              }
            }

          }
          Row() {
            Text("用户2:")
          }.width('100%').margin({top:10,bottom:10})

          List({ space: 10 }) {
            ListItem() {
              Row() {
                Text('姓名:').width(90).textAlign(TextAlign.End).margin({ right: 10 })
                TextInput().width(250).borderRadius(5).onChange((val) => {
                  this.info.combinationName1=val;
                })
              }
            }

            ListItem() {
              Row() {
                Text('联系方式:').width(90).textAlign(TextAlign.End).margin({ right: 10 })
                TextInput().width(250).borderRadius(5).onChange((val) => {
                  this.info.combinationPhone1=val;
                })
              }
            }

            ListItem() {
              Row() {
                Text('身份证号:').width(90).textAlign(TextAlign.End).margin({ right: 10 })
                TextInput().width(250).borderRadius(5).onChange((val) => {
                  this.info.combinationIdnum1=val
                })
              }
            }

          }

          Row() {
            Text("上传材料:")
          }.width('100%').margin({top:10,bottom:10})
          List(){
            ListItem() {
              Row() {
                Text('上传材料:').width(90).textAlign(TextAlign.End).margin({ right: 10 })
                Text('+')
                  .width(90)
                  .height(90).fontSize(30)
                  .textAlign(TextAlign.Center)
                  .borderWidth(1)
                  .borderStyle(BorderStyle.Dashed)
                  .borderRadius(10)
                  .onClick(() => {
                    this.getAllImg()
                  }).margin({right:10})
                Image(this.imgDatas[0]).width(90)
                  .height(90)
              }
            }
          }
        }.layoutWeight(1)

        Row() {
          Button("申请").type(ButtonType.Normal).borderRadius(5).margin({ right: 10 }).onClick(() => {
            this.addFinanceMulti()
          })
          Button("取消").type(ButtonType.Normal).borderRadius(5).onClick(() => {
            router.back();
          })
        }.height(60)
      }
      .width('100%')
    }
    .height('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }
}