import router from '@ohos.router'

@Entry
@Component
struct MyReserveInfoPage {
  @State item: any = {}

  aboutToAppear() {
    this.item = JSON.parse(router.getParams()["info"]);
  }

  build() {
    Row() {
      Column() {
        Stack({ alignContent: Alignment.Start }) {
          Text('预约信息')
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
          //基本信息
          List() {
            ListItem() {
              Row() {
                Text('种植作物:').width(120)
                Text(this.item.plantName)
              }
            }.padding({ left: 20, right: 20 }).height(60)

            ListItem() {
              Row() {
                Text('作物详细信息:').width(120)
                Text(this.item.plantDetail)
              }
            }.padding({ left: 20, right: 20 }).height(60)

            ListItem() {
              Row() {
                Text('地址:').width(120)
                Text(this.item.address)
              }
            }.padding({ left: 20, right: 20 }).height(60)

            ListItem() {
              Row() {
                Text('土壤条件:').width(120)
                Text(this.item.soilCondition)
              }
            }.padding({ left: 20, right: 20 }).height(60)

            ListItem() {
              Row() {
                Text('面积:').width(120)
                Text(this.item.area)
              }
            }.padding({ left: 20, right: 20 }).height(60)

            ListItem() {
              Row() {
                Text('作物条件:').width(120)
                Text(this.item.plantCondition)
              }
            }.padding({ left: 20, right: 20 }).height(60)

            ListItem() {
              Row() {
                Text('当前状态:').width(120)
                if (this.item.status == 0) {
                  Text('未处理').backgroundColor('#fef0f0').fontColor('#f56c6c').margin(3).padding(5)
                } else {
                  Text('已处理').backgroundColor('#409eff').fontColor('#f5f7fa').margin(3).padding(5)
                }
              }
            }.padding({ left: 20, right: 20 }).height(60)

          }.divider({ strokeWidth: 1, color: '#f1f1f1', startMargin: 20, endMargin: 20 }) // 每行之间的分界线
          .borderRadius(10)
          .margin(5)
          .backgroundColor('#ffffff')
        }.layoutWeight(1)

      }
      .width('100%')
    }
    .height('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }
}