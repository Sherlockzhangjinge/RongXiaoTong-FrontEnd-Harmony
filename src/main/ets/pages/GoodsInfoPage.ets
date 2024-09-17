import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import http from '@ohos.net.http';
import { baseUrl } from '../api/BaseData';
import { addToCar } from '../api/CarApi';
import { getlatlng } from '../api/CityApi';

@Entry
@Component
struct GoodsInfoPage {
  @State info: any = '';
  @State isShow: boolean = false
  @State distance: number = 0
  latlng: any = {}

  async aboutToAppear() {
    this.info = router.getParams()['info'];
    getlatlng(this.info.address).then(res => {
      let result = JSON.parse(res.result.toString())
      let location = result.sites[0].location
      this.latlng = {
        olat: globalThis.lat,
        olng: globalThis.lng,
        dlat: location.lat,
        dlng: location.lng
      }
      this.distance = parseFloat(this.getDistance(globalThis.lat, globalThis.lng, location.lat, location.lng)
        .toFixed(2))

    }).catch(err => {

    })
  }
  // Haversine 公式,计算经纬度和位置转换
  getDistance(lat1, lon1, lat2, lon2) {

    const R = 6371; // 地球半径，单位为千米
    const dLat = Math.abs(this.toRadians(lat2 - lat1));
    const dLon = Math.abs(this.toRadians(lon2 - lon1));
    // @ts-ignore
    const plon1 = Math.abs(this.toRadians(lon1))
    const plon2 = Math.abs(this.toRadians(lon2))
    const a = Math.pow((Math.sin(dLon / 2)), 2) + Math.pow(Math.sin(dLat / 2), 2) * Math.cos(plon1) * Math.cos(plon2);
    const distance = 2 * R * Math.asin(Math.sqrt(a));
    return distance;
  }

  toRadians(degrees) {
    return degrees * (Math.PI / 180);
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Stack({ alignContent: Alignment.Start }) {
        Text('详细信息')
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
      }.height(60).width('100%').margin({ top: 10 }).zIndex(1)

      Column() {
        Image(`${baseUrl}/file/${this.info.picture}`)
          .width('100%')
          .height(300)
          .margin({ bottom: 10 })
          .borderRadius(10)
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text(this.info.title).fontSize(30)
        }.height(60)

        Divider().margin(10).color(Color.Gray)
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
          Text(this.info.content).fontSize(20)
        }.height(160).padding({ left: 10 })

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text(`￥${this.info.price}`).fontSize(25).fontColor(Color.Red)
        }.height(40).padding({ left: 10 })

        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text(`发布时间:${this.info.createTime.substring(0, 10)}`).fontSize(16)
          Text(`最近修改时间:${this.info.updateTime.substring(0, 10)}`).fontSize(16)
        }.height(50).padding({ left: 10 }).margin({ bottom: 10 })

        Flex({ justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
          Column() {
            Image($r('app.media.map'))
              .width(30).height(30).margin({ bottom: 5 })
          }.onClick(() => {
            router.pushUrl(
              {
                url: 'pages/map',
                params: { param: this.latlng }
              })
          }).width(35)

          Column() {
            Text(this.info.address).fontWeight(FontWeight.Bold).fontSize(16)
            Text(`买家距您${this.distance}公里`).fontSize(14).fontColor(Color.Gray)
          }.align(Alignment.Start)

          Column() {
            Button('加入购物车')
              .visibility(this.info.type == 'goods' ? Visibility.Visible : Visibility.None)
              .backgroundColor(Color.Red)
              .onClick(() => {
                if (globalThis.token) {
                  let id = this.info.orderId
                  addToCar(this.info.orderId).then((res) => {
                    let rst = JSON.parse(res.result.toString());
                    if (rst.code == 20000) {
                      promptAction.showToast({ message: "添加商品到购物车成功！", duration: 2000 })
                    } else {
                      promptAction.showToast({ message: "添加商品到购物车失败！", duration: 2000 })
                    }
                  })
                } else {
                  AlertDialog.show({
                    title: '提示',
                    message: "请先登录！",
                    primaryButton: {
                      value: '确定',
                      action: () => {
                      }
                    }
                  })
                }
              })
            Button('联系买家')
              .visibility(this.info.type == 'needs' ? Visibility.Visible : Visibility.None)
              .onClick(() => {
                this.isShow = true;
              })
          }
        }.margin({ bottom: 10 })

      }.zIndex(-1).margin({ top: 70, bottom: 10, left: 10, right: 10 })

      //显示卖家信息
      Panel(this.isShow) {
        Column() {
          List() {
            ListItem() {
              Text("买家姓名:" + this.info.ownName)
            }.padding({ left: 20, right: 20 }).height(60)

            ListItem() {
              Text("买家地址:" + this.info.address)
            }.padding({ left: 20, right: 20 }).height(60)

            ListItem() {
              Row() {
                Button("取消").type(ButtonType.Normal).onClick(() => {
                  this.isShow = false;
                })
              }.width('100%').justifyContent(FlexAlign.Center)
            }.padding({ left: 20, right: 20 }).height(60)
          }.divider({ strokeWidth: 1, color: '#f1f1f1', startMargin: 20, endMargin: 20 })
        }
      }
      .type(PanelType.Foldable).mode(PanelMode.Half)
      .dragBar(true) // 默认开启
      .halfHeight(200) // 默认一半
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)

  }
}