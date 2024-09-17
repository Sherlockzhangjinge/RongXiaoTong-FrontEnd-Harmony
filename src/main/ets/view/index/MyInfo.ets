import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { baseUrl } from '../../api/BaseData';
import { getInfo } from '../../api/LoginApi';

@Preview
@Entry
@Component
export struct MyInfo {
  private scroller: Scroller = new Scroller();
  @State info: any = ''
  @State role: string = 'user'

  aboutToAppear() {
    if (globalThis.info) {
      this.info = globalThis.info
      this.role = this.info.role
    }
    else if (globalThis.token) {
      getInfo().then((res) => {
        let resData = JSON.parse(res.result.toString())
        this.info = resData.data
        this.role = this.info.role
        globalThis.info = resData.data

      })
    }
  }

  build() {
    Column() {
      Column() {
        Row() {
          Text('我的')
            .fontColor('#F8FAFC')
            .width(44)
            .height(28)
            .fontSize(22)
            .margin({ top: 14, left: 24 })
        }.width('100%')

        Row() {
          if (this.info) {
            Image(`${baseUrl}/file/${this.info.avatar}`).width(70).height(70).borderRadius(35)
          } else {
            Image($r('app.media.nologin')).width(70).height(70).borderRadius(35)
          }
          Row() {
            if (this.info) {
              Column() {
                Text(this.info.userName)
                  .fontSize(18)
                  .fontColor('#FFFFFF')
                  .fontWeight(700)
                  .height(25)
                  .textAlign(TextAlign.Start)
                Text(this.info.phone)
                  .fontSize(14)
                  .fontColor('#FFFFFF')
                  .fontWeight(400)
                  .height(20)
                  .textAlign(TextAlign.Start)
              }

              Row() {
                Text('修改资料').height(30).fontSize(12).fontColor('#FFFFFF').margin({ right: 5 })
                Image($r('app.media.chevron_right')).width(20).height(20)

              }
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/UserInfoPage',
                  params: { info: JSON.stringify(this.info) }
                })
              })
            } else {
              Text('登  录')
                .fontSize(18)
                .fontColor('#FFFFFF')
                .fontWeight(700)
                .height(25)
                .onClick(() => {
                  router.pushUrl({ url: "pages/LoginPage" })
                })
            }
          }.margin({ left: 17 }).justifyContent(FlexAlign.SpaceBetween).flexGrow(1)
        }
        .width('100%')
        .padding({ left: 24, right: 24 })
        .height(67)
        .margin({ top: 20 })
        .alignItems(VerticalAlign.Center)
      }
      .width('100%')
      .height(185)
      .backgroundColor('#35ce3a')
      //用户导航
      if (this.role == "user") {
        Row() {
          //1
          Blank()
          Column() {
            Image($r('app.media.3D')).width(30).height(30)
            Text('我的问答').fontColor('#666666').fontSize(14).height(25)
          }.onClick(() => {
            if (!globalThis.token) {
              promptAction.showToast({ message: "请先登录！", duration: 2000 })
            } else {
              router.pushUrl({ url: 'pages/info/MyQuestionPage' })
            }
          })
          .justifyContent(FlexAlign.Center)

          Blank()
          //2
          Column() {
            Image($r('app.media.Clock1')).width(30).height(30)

            Text('我的预约').fontColor('#666666').fontSize(14).height(25)
          }.onClick(() => {
            if (!globalThis.token) {
              promptAction.showToast({ message: "请先登录！", duration: 2000 })
            } else {
              router.pushUrl({ url: 'pages/info/MyReservePage' })
            }
          })
          .justifyContent(FlexAlign.Center)

          Blank()
          //3
          Column() {
            Image($r('app.media.car')).width(30).height(30)

            Text('我买的').fontColor('#666666').fontSize(14).height(25)

          }.onClick(() => {
            if (!globalThis.token) {
              promptAction.showToast({ message: "请先登录！", duration: 2000 })
            } else {
              router.pushUrl({ url: 'pages/info/MyBuysPage' })
            }

          })
          .justifyContent(FlexAlign.Center)

          Blank()
          //4
          Column() {
            Image($r('app.media.Inbox')).width(30).height(30)

            Text('我卖的').fontColor('#666666').fontSize(14).height(25)

          }.onClick(() => {
            if (!globalThis.token) {
              promptAction.showToast({ message: "请先登录！", duration: 2000 })
            } else {
              router.pushUrl({ url: 'pages/info/MySellsPage' })
            }
          })
          .justifyContent(FlexAlign.Center)

          Blank()
        }
        .width(351)
        .height(90)
        .backgroundColor('#FFFFFF')
        .margin({ top: -40, left: 12, right: 12 })
        .borderRadius(10)
        .shadow({ radius: 4, color: '#EBEBEB', offsetX: 0, offsetY: 2 })
        .justifyContent(FlexAlign.SpaceAround)
      }

      //专家导航
      if (this.role == "expert") {
        Row() {
          //1
          Blank()
          Column() {
            Image($r('app.media.3D')).width(30).height(30)
            Text('我的问答').fontColor('#666666').fontSize(14).height(25)
          }.onClick(() => {
            router.pushUrl({ url: "pages/info/expert/ExpertQustionAllPage" })
          })
          .justifyContent(FlexAlign.Center)

          Blank()
          //2
          Column() {
            Image($r('app.media.Clock1')).width(30).height(30)
            Text('我的预约').fontColor('#666666').fontSize(14).height(25)
          }.onClick(() => {
            router.pushUrl({ url: "pages/info/expert/ExpertReserveAllPage" })
          })
          .justifyContent(FlexAlign.Center)

          Blank()
          //3
          Column() {
            Image($r('app.media.car')).width(30).height(30)
            Text('我的知识').fontColor('#666666').fontSize(14).height(25)
          }.onClick(() => {
            if (!globalThis.token) {
              promptAction.showToast({ message: "请先登录！", duration: 2000 })
            } else {
              router.pushUrl({ url: 'pages/info/expert/ExpertKnowledgePage' })
            }
          }).justifyContent(FlexAlign.Center)

          Blank()
          //4
          Column() {
            Image($r('app.media.Inbox')).width(30).height(30)
            Text('专家信息').fontColor('#666666').fontSize(14).height(25)
          }.onClick(() => {
            if (!globalThis.token) {
              promptAction.showToast({ message: "请先登录！", duration: 2000 })
            } else {
              router.pushUrl({ url: 'pages/info/expert/SearchExpertInfoPage' })
            }
          })
          .justifyContent(FlexAlign.Center)

          Blank()
        }
        .width(351)
        .height(90)
        .backgroundColor('#FFFFFF')
        .margin({ top: -40, left: 12, right: 12 })
        .borderRadius(10)
        .shadow({ radius: 4, color: '#EBEBEB', offsetX: 0, offsetY: 2 })
        .justifyContent(FlexAlign.SpaceAround)
      }

      //管理员
      if (this.role == "admin") {
        Row() {
          Text("欢迎管理员登录")
        }
        .width(351)
        .height(90)
        .margin({ top: -40, left: 12, right: 12 })
        .backgroundColor('#FFFFFF')
        .borderRadius(10)
        .shadow({ radius: 4, color: '#EBEBEB', offsetX: 0, offsetY: 2 })
        .justifyContent(FlexAlign.SpaceAround)
      }
      Text('基础信息')
        .fontSize(16)
        .fontColor('#0F172A')
        .height(30)
        .width('100%')
        .margin({ left: 20, top: 10, bottom: 10 })
      if (this.role == "user") {
        List() {
          ListItem() {
            //1
            Row() {
              Image($r('app.media.user')).width(20).height(20).margin({ right: 10 })
              Text('我的需求')
                .height(20)
                .fontSize(16)
                .fontColor('#0F172A')
                .flexGrow(1)
                .fontWeight(400)
              Image($r('app.media.chevron_right')).width(16).width(16)
            }.onClick(() => {
              if (!globalThis.token) {
                promptAction.showToast({ message: "请先登录！", duration: 2000 })
              } else {
                router.pushUrl({ url: 'pages/MyGoodsPage', params: { type: 'needs' } })
              }
            })
            .width('100%').height(55).padding({ left: 20, right: 20 })
          }

          ListItem() {
            //2
            Row() {
              Image($r('app.media.tabler_credit_card')).width(20).height(20).margin({ right: 10 })
              Text('我发布的')
                .height(20)
                .fontSize(16)
                .fontColor('#0F172A')
                .flexGrow(1)
                .fontWeight(400)
              Image($r('app.media.chevron_right')).width(16).width(16)
            }.onClick(() => {
              if (!globalThis.token) {
                promptAction.showToast({ message: "请先登录！", duration: 2000 })
              } else {
                router.pushUrl({ url: 'pages/MyGoodsPage', params: { type: 'goods' } })
              }
            }).width('100%').height(55).padding({ left: 20, right: 20 })
          }

          ListItem() {
            //4
            Row() {
              Image($r('app.media.map_pin')).width(20).height(20).margin({ right: 10 })
              Text('收货地址')
                .height(20)
                .fontSize(16)
                .fontColor('#0F172A')
                .flexGrow(1)
                .fontWeight(400)
              Image($r('app.media.chevron_right')).width(16).width(16)
            }.onClick(() => {
              if (!globalThis.token) {
                promptAction.showToast({ message: "请先登录！", duration: 2000 })
              } else {
                router.pushUrl({ url: 'pages/ShowAddressPage', params: { type: 'goods' } })
              }
            }).width('100%').height(55).padding({ left: 20, right: 20 })
          }
        }.backgroundColor('#ffffff')
        .divider({ strokeWidth: 1, color: '#f1f1f1', startMargin: 0, endMargin: 0 }) // 每行之间的分界线
      }

      if (this.role == "expert") {
        List() {
          ListItem() {
            //4
            Row() {
              Image($r('app.media.fabu')).width(20).height(20).margin({ right: 10 })
              Text('发布知识')
                .height(20)
                .fontSize(16)
                .fontColor('#0F172A')
                .flexGrow(1)
                .fontWeight(400)
              Image($r('app.media.chevron_right')).width(16).width(16)
            }.onClick(() => {
              if (!globalThis.token) {
                promptAction.showToast({ message: "请先登录！", duration: 2000 })
              } else {
                router.pushUrl({ url: 'pages/info/expert/ExpertKnowledgeEditPage', params: { type: 'add' } })
              }
            })
            .width('100%').height(55).padding({ left: 20, right: 20 })
          }

          ListItem() {
            //4
            Row() {
              Image($r('app.media.map_pin')).width(20).height(20).margin({ right: 10 })
              Text('收货地址')
                .height(20)
                .fontSize(16)
                .fontColor('#0F172A')
                .flexGrow(1)
                .fontWeight(400)
              Image($r('app.media.chevron_right')).width(16).width(16)
            }.width('100%').height(55).padding({ left: 20, right: 20 })
          }
        }.backgroundColor('#ffffff')
        .divider({ strokeWidth: 1, color: '#f1f1f1', startMargin: 0, endMargin: 0 }) // 每行之间的分界线

      }

      //管理员
      if (this.role == "admin") {
        List() {
          ListItem() {
            //4
            Row() {
              Image($r('app.media.user')).width(20).height(20).margin({ right: 10 })
              Text('用户管理')
                .height(20)
                .fontSize(16)
                .fontColor('#0F172A')
                .flexGrow(1)
                .fontWeight(400)
              Image($r('app.media.chevron_right')).width(16).width(16)
            }
            .onClick(() => {
              router.pushUrl({ url: 'pages/admin/ShowUsersPage' })
            })
            .width('100%').height(55).padding({ left: 20, right: 20 })
          }

          ListItem() {
            //4
            Row() {
              Image($r('app.media.goods')).width(20).height(20).margin({ right: 10 })
              Text('商品货源')
                .height(20)
                .fontSize(16)
                .fontColor('#0F172A')
                .flexGrow(1)
                .fontWeight(400)
              Image($r('app.media.chevron_right')).width(16).width(16)
            }.onClick(() => {
              router.pushUrl({ url: 'pages/MyGoodsPage', params: { type: 'goods' } })
            })
            .width('100%').height(55).padding({ left: 20, right: 20 })
          }

          ListItem() {
            //4
            Row() {
              Image($r('app.media.goods')).width(20).height(20).margin({ right: 10 })
              Text('求购需求')
                .height(20)
                .fontSize(16)
                .fontColor('#0F172A')
                .flexGrow(1)
                .fontWeight(400)
              Image($r('app.media.chevron_right')).width(16).width(16)
            }.onClick(() => {
              router.pushUrl({ url: 'pages/MyGoodsPage', params: { type: 'needs' } })
            }).width('100%').height(55).padding({ left: 20, right: 20 })
          }
        }.backgroundColor('#ffffff')
        .divider({ strokeWidth: 1, color: '#f1f1f1', startMargin: 0, endMargin: 0 }) // 每行之间的分界线
      }

      //其他
      Text('融资信息')
        .fontSize(16)
        .fontColor('#0F172A')
        .height(30)
        .width('100%')
        .margin({ left: 20, top: 10, bottom: 10 })
      List() {
        ListItem() {
          //1
          Row() {
            Image($r('app.media.message_dots')).width(20).height(20).margin({ right: 10 })
            Text('智能匹配')
              .height(20)
              .fontSize(16)
              .fontColor('#0F172A')
              .flexGrow(1)
              .fontWeight(400)
            Image($r('app.media.chevron_right')).width(16).width(16)
          }.width('100%').height(55).padding({ left: 20, right: 20 })
          .onClick(() => {
            if (!globalThis.token) {
              promptAction.showToast({ message: "请先登录！", duration: 2000 })
            } else {
              router.pushUrl({ url: 'pages/finance/RecommendRzrPage' })
            }

          })
        }

        ListItem() {
          //2
          Row() {
            Image($r('app.media.notes')).width(20).height(20).margin({ right: 10 })
            Text('融资申请')
              .height(20)
              .fontSize(16)
              .fontColor('#0F172A')
              .flexGrow(1)
              .fontWeight(400)
            Image($r('app.media.chevron_right')).width(16).width(16)
          }.width('100%').height(55).padding({ left: 20, right: 20 })
          .onClick(() => {
            if (!globalThis.token) {
              promptAction.showToast({ message: "请先登录！", duration: 2000 })
            } else {
              router.pushUrl({ url: 'pages/finance/ShowBankPage' })
            }

          })
        }

        ListItem() {
          //2
          Row() {
            Image($r('app.media.star')).width(20).height(20).margin({ right: 10 })
            Text('我的融资')
              .height(20)
              .fontSize(16)
              .fontColor('#0F172A')
              .flexGrow(1)
              .fontWeight(400)
            Image($r('app.media.chevron_right')).width(16).width(16)
          }.onClick(() => {
            if (!globalThis.token) {
              promptAction.showToast({ message: "请先登录！", duration: 2000 })
            } else {
              router.pushUrl({ url: 'pages/finance/MyFinancePage' })
            }
          })
          .width('100%').height(55).padding({ left: 20, right: 20 })
        }
      }.backgroundColor('#ffffff')
      .divider({ strokeWidth: 1, color: '#f1f1f1', startMargin: 0, endMargin: 0 }) // 每行之间的分界线
      //其他
      Text('其他操作')
        .fontSize(16)
        .fontColor('#0F172A')
        .height(30)
        .width('100%')
        .margin({ left: 20, top: 10, bottom: 10 })
      List() {
        ListItem() {
          //1
          Row() {
            Image($r('app.media.ic_menu_back')).width(20).height(20).margin({ right: 10 })
            Text('注销')
              .height(20)
              .fontSize(16)
              .fontColor('#0F172A')
              .flexGrow(1)
              .fontWeight(400)
            // Image($r('app.media.chevron_right')).width(16).width(16)
          }.width('100%').height(55).padding({ left: 20, right: 20 })
          .onClick(() => {
            globalThis.token = ''
            globalThis.info = null
            router.pushUrl({ url: 'pages/Index' })
          })
        }
      }.backgroundColor('#ffffff')
      .divider({ strokeWidth: 1, color: '#f1f1f1', startMargin: 0, endMargin: 0 }) // 每行之间的分界线

    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.bg4'))
    .backgroundImageSize(ImageSize.Cover)
  }
}