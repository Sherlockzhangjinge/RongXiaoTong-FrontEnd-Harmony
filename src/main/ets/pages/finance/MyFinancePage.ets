import http from '@ohos.net.http';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { baseUrl } from '../../api/BaseData';
import { deleteMyFinance, getMyFinance, getShowBank, updateFinanceInfo } from '../../api/FinanceApi';
@Preview
@Entry
@Component
  //我的融资
struct MyFinancePage {
  @State myFinanceAll: any = [];
  private scroller: Scroller = new Scroller();
  @State banks: any = [];
  @State item: any = {};
  @State isShow: boolean = false;
  @State qiXians: Array<string> = ['6', '12', '24', '36']
  @State years: Array<string> = ['六个月', '一年', '二年', '三年']

  getShowBank() {
    getShowBank().then(data=>{
      this.banks = [];
      let imageDataArray = JSON.parse(data.result.toString()).data;
      for (let b of imageDataArray) {
        this.banks.push(b);
      }
    })
  }

  getMyFinance() {
    getMyFinance().then(data=>{
      this.myFinanceAll = [];
      let datas = JSON.parse(data.result.toString()).data;
      for (let d of datas) {
        this.myFinanceAll.push(d);
      }
    })
  }

  getBankName(bankId) {
    let bankName = '';
    for (let b of this.banks) {
      if (bankId == b.bankId) {
        bankName = b.bankName;
        break;
      }
    }
    return bankName;
  }

  updateFinanceInfo() {
    updateFinanceInfo(this.item).then(data=>{
      let code = JSON.parse(data.result.toString()).code;
      if (code == 20000) {
        promptAction.showToast({
          message: '修改成功!',
          duration: 1000,
        });
        this.getMyFinance()
        this.isShow=false
      } else {
        promptAction.showToast({
          message: '修改失败!',
          duration: 2000,
        });
      }
    })
  }

  aboutToAppear() {
    this.getShowBank();
    this.getMyFinance()
  }

  build() {
    Row() {
      Stack({ alignContent: Alignment.Top }) {
        Stack({ alignContent: Alignment.Start }) {
          Text('融资信息')
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

        if(this.myFinanceAll.length==0){
          Column() {
            Image($r('app.media.illustration_3x')).width(200).height(200)
            Text("没有融资信息")
              .fontSize(24)
              .fontColor('#0F172A')
              .height(50)
              .lineHeight(50)
              .fontWeight(400)
          }.justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
          .width('100%').height('100%').margin({top:60}).zIndex(-1)
        }else{
          Column(){
            Scroll(this.scroller) {
              Column() {
                ForEach(this.myFinanceAll, (item, index) => {
                  Column() {
                    Row() {
                      Text("融资信息" + (index + 1))
                      Blank()
                      if (item.status == 0) {
                        Button('修改').type(ButtonType.Normal)
                          .margin({ right: 10 }).borderRadius(5)
                          .onClick(() => {
                            this.item = item;
                            this.isShow = true;
                          })
                      }
                      if (item.status == 1) {
                        Text('已通过审批').fontColor('#409eff').padding({right:10})
                      }
                      if (item.status == 2) {
                        Text('未通过审批').fontColor('#fff83e63').padding({right:10})

                      }
                      if (item.status == 0 || item.status == 2) {
                        Button('删除')
                          .type(ButtonType.Normal)
                          .margin({ right: 10 })
                          .borderRadius(5)
                          .onClick(() => {
                            AlertDialog.show({
                              title: '提示',
                              message: "你确定要删除该融资信息吗？",
                              primaryButton: {
                                value: '取消',
                                action: () => {

                                }
                              },
                              secondaryButton: {
                                value: '确定',
                                action: () => {
                                  deleteMyFinance(item.financeId).then(rst=>{
                                    let code = JSON.parse(rst.result.toString()).code;
                                    if (code == 20000) {
                                      promptAction.showToast({
                                        message: '删除成功!',
                                        duration: 1000,
                                      });
                                      this.getMyFinance();
                                    } else {
                                      promptAction.showToast({
                                        message: '删除失败!',
                                        duration: 2000,
                                      });
                                    }
                                  })
                                }
                              }
                            })
                          })

                      }
                    }
                    .width('100%')
                    .margin({ top: 10, bottom: 10 })
                    .padding({ left: 10, right: 10 })
                    List({ space: 10 }) {
                      ListItem() {
                        Row() {
                          Text('姓名:').width(150).textAlign(TextAlign.End).margin({ right: 10 })
                          Text(item.realName)
                        }.width('100%').height(55)
                      }

                      ListItem() {
                        Row() {
                          Text('手机号:').width(150).textAlign(TextAlign.End).margin({ right: 10 })
                          Text(item.phone)
                        }.width('100%').height(55)
                      }

                      ListItem() {
                        Row() {
                          Text('身份证号:').width(150).textAlign(TextAlign.End).margin({ right: 10 })
                          Text(item.idNum)
                        }.width('100%').height(55)
                      }

                      ListItem() {
                        Row() {
                          Text('融资金额:').width(150).textAlign(TextAlign.End).margin({ right: 10 })
                          Text(item.money + '')
                        }.width('100%').height(55)
                      }

                      ListItem() {
                        Row() {
                          Text('银行:').width(150).textAlign(TextAlign.End).margin({ right: 10 })
                          Text(this.getBankName(item.bankId))
                        }.width('100%').height(55)
                      }

                      ListItem() {
                        Row() {
                          Text('利率:').width(150).textAlign(TextAlign.End).margin({ right: 10 })
                          Text(item.rate + '')
                        }.width('100%').height(55)
                      }

                      ListItem() {
                        Row() {
                          Text('申请状态:').width(150).textAlign(TextAlign.End).margin({ right: 10 })
                          Text(item.status == 0 ? '申请中' : '已通过')
                        }.width('100%').height(55)
                      }

                      ListItem() {
                        Row() {
                          Text('联合融资人1姓名:').width(150).textAlign(TextAlign.End).margin({ right: 10 })
                          Text(item.combinationName1)
                        }.width('100%').height(55)
                      }

                      ListItem() {
                        Row() {
                          Text('联合融资人1手机号:').width(150).textAlign(TextAlign.End).margin({ right: 10 })
                          Text(item.combinationPhone1)
                        }.width('100%').height(55)
                      }

                      ListItem() {
                        Row() {
                          Text('联合融资人1身份证:').width(150).textAlign(TextAlign.End).margin({ right: 10 })
                          Text(item.combinationIdnum1)
                        }.width('100%').height(55)
                      }

                      ListItem() {
                        Row() {
                          Text('联合融资人2姓名:').width(150).textAlign(TextAlign.End).margin({ right: 10 })
                          Text(item.combinationName2)
                        }.width('100%').height(55)
                      }

                      ListItem() {
                        Row() {
                          Text('联合融资人2手机号:').width(150).textAlign(TextAlign.End).margin({ right: 10 })
                          Text(item.combinationPhone2)
                        }.width('100%').height(55)
                      }

                      ListItem() {
                        Row() {
                          Text('联合融资人2身份证:').width(150).textAlign(TextAlign.End).margin({ right: 10 })
                          Text(item.combinationIdnum2)
                        }.width('100%').height(55)
                      }
                    }.backgroundColor('#ffffff')
                    .divider({ strokeWidth: 1, color: '#f1f1f1', startMargin: 0, endMargin: 0 })
                    .borderRadius(10)
                  }.width('100%').borderRadius(10).backgroundColor("#f1f1f1")
                }, item => item.financeId);
              }.width('100%')
            }.scrollable(ScrollDirection.Vertical)
          }
          .layoutWeight(1)
          .height('100%')
          .margin({ top: 80 })

        }
        Panel(this.isShow) {
          Column() {
            Text('修改融资信息').height(60)
            List({ space: 10 }) {
              ListItem() {
                Row() {
                  Text('融资金额:').width(150).textAlign(TextAlign.End).margin({ right: 10 })
                  TextInput({ text: this.item.money + '' }).width(240).borderRadius(5).height(45)
                    .onChange((v) => {
                      this.item.money = v;
                    })
                }.width('100%').height(55)
              }

              ListItem() {
                Row() {
                  Text('意向借款期:').width(150).textAlign(TextAlign.End).margin({ right: 10 })
                  Select([{ value: '六个月' }, { value: '一年' }, { value: '二年' }, { value: '三年' }])
                    .value(this.years[parseInt(this.item.repayment / 12 + '')])
                    .onSelect((index: number) => {
                      this.item.repayment = this.qiXians[index];
                    })
                    .width(160)
                    .margin({ left: 10 })
                    .borderRadius(5)
                  Text('单位：月')
                }.width('100%').height(55)
              }

              ListItem() {
                Row() {
                  Text('联合融资人1姓名:').width(150).textAlign(TextAlign.End).margin({ right: 10 })
                  TextInput({ text: this.item.combinationName1 }).width(240).borderRadius(5).height(45)
                    .onChange((v) => {
                      this.item.combinationName1 = v;
                    })
                }.width('100%').height(55)
              }

              ListItem() {
                Row() {
                  Text('联合融资人1手机号:').width(150).textAlign(TextAlign.End).margin({ right: 10 })
                  TextInput({ text: this.item.combinationPhone1 }).width(240).borderRadius(5).height(45)
                    .onChange((v) => {
                      this.item.combinationPhone1 = v;
                    })
                }.width('100%').height(55)
              }

              ListItem() {
                Row() {
                  Text('联合融资人1身份证:').width(150).textAlign(TextAlign.End).margin({ right: 10 })
                  TextInput({ text: this.item.combinationIdnum1 }).width(240).borderRadius(5).height(45)
                    .onChange((v) => {
                      this.item.combinationIdnum1 = v;
                    })
                }.width('100%').height(55)
              }

              ListItem() {
                Row() {
                  Text('联合融资人2姓名:').width(150).textAlign(TextAlign.End).margin({ right: 10 })
                  TextInput({ text: this.item.combinationName2 }).width(240).borderRadius(5).height(45)
                    .onChange((v) => {
                      this.item.combinationName2 = v;
                    })
                }.width('100%').height(55)
              }

              ListItem() {
                Row() {
                  Text('联合融资人2手机号:').width(150).textAlign(TextAlign.End).margin({ right: 10 })
                  TextInput({ text: this.item.combinationPhone2 }).width(240).borderRadius(5).height(45)
                    .onChange((v) => {
                      this.item.combinationPhone2 = v;
                    })
                }.width('100%').height(55)
              }

              ListItem() {
                Row() {
                  Text('联合融资人2身份证:').width(150).textAlign(TextAlign.End).margin({ right: 10 })
                  TextInput({ text: this.item.combinationIdnum2 }).width(240).borderRadius(5).height(45)
                    .onChange((v) => {
                      this.item.combinationIdnum2 = v;
                    })
                }.width('100%').height(55)
              }
            }
            .divider({ strokeWidth: 1, color: '#f1f1f1', startMargin: 0, endMargin: 0 })
            .layoutWeight(1)

            Row() {
              Button('确定').type(ButtonType.Normal).borderRadius(5).margin({ right: 20 })
                .onClick(() => {
                  this.updateFinanceInfo();
                })

              Button('取消').type(ButtonType.Normal).borderRadius(5).onClick(() => {
                this.isShow = false;
              })
            }.height(60)
          }
        }
        .type(PanelType.Foldable).mode(PanelMode.Full)
        .halfHeight(500) // 默认一半
        .dragBar(false)
      }
      .width('100%')
    }
    .height('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }
}