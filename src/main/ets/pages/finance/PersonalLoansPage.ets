import router from '@ohos.router';
import picker from '@ohos.file.picker';

import request from '@ohos.request';
import fs from '@ohos.file.fs'
import common from '@ohos.app.ability.common';
import { baseUrl } from '../../api/BaseData';
import promptAction from '@ohos.promptAction';
import { financeAdd } from '../../api/FinanceApi';

let context = getContext(this) as common.UIAbilityContext;

/**
 * 个人贷款
 */
@Preview
@Entry
@Component
struct PersonalLoansPage {
  @State bank: any = {};
  @State uri: any = ''
  @State imgDatas: string[] = [];
  private uploadTask: request.UploadTask;
  @State resultMsg: string = '66666666666666'
  @State realName: string = ''
  @State idNum: string = ''
  @State money: string = ''
  @State repayment: string = ''
  @State repayments: string[] = ["6", "12", "24", "36"];
  @State phone: string = ''

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

  financeAdd() {
    let item ={
      bankId: this.bank.bankId,
      fileInfo:this.bank.fileInfo,
      idNum: this.idNum,
      money: this.money,
      phone: this.phone,
      rate: this.bank.rate,
      realName: this.realName,
      repayment: this.repayment
    }
    financeAdd(item)
      .then(rst => {
        console.info("=================",rst.result.toString())
        let data = JSON.parse(rst.result.toString());
        if (data.code == 20000) {
          promptAction.showToast({ message: '申请成功!', duration: 2000 })
        } else {
          promptAction.showToast({ message: data.message, duration: 2000 })
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
          Text('个人贷款信息')
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

        List({ space: 10 }) {
          ListItem() {
            Row() {
              Text('姓名:').width(90).textAlign(TextAlign.End).margin({ right: 10 })
              TextInput().width(250).borderRadius(5).onChange((val) => {
                this.realName = val;
              })
            }
          }

          ListItem() {
            Row() {
              Text('融资额度:').width(90).textAlign(TextAlign.End).margin({ right: 10 })
              TextInput().width(250).borderRadius(5).onChange((val) => {
                this.money = val;
              })
            }
          }

          ListItem() {
            Row() {
              Text('利息:').width(90).textAlign(TextAlign.End).margin({ right: 10 })
              Text(this.bank.rate + '')
            }
          }
          ListItem() {
            Row() {
              Text('意向借款期:').width(90).textAlign(TextAlign.End).margin({ right: 10 })
              Select([{ value: '六个月' }, { value: '一年' }, { value: '二年' }, { value: '三年' }])
                .value('请选择意向借款期')
                .onSelect((index: number) => {
                  this.repayment = this.repayments[index];
                })
                .width(250)
                .borderRadius(5)
            }
          }

          ListItem() {
            Row() {
              Text('联系方式:').width(90).textAlign(TextAlign.End).margin({ right: 10 })
              TextInput().width(250).borderRadius(5).onChange((val) => {
                this.phone = val;
              })
            }
          }

          ListItem() {
            Row() {
              Text('身份证号:').width(90).textAlign(TextAlign.End).margin({ right: 10 })
              TextInput().width(250).borderRadius(5).onChange((val) => {
                this.idNum = val;
              })
            }
          }

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

        }.layoutWeight(1)

        Row() {
          Button("申请").type(ButtonType.Normal).borderRadius(5).margin({ right: 10 }).onClick(() => {
            this.financeAdd()
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