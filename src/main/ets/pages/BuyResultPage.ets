/**
 * 我买的
 */
import router from '@ohos.router'


@Preview
@Entry
@Component
struct BuyResultPage {
  @State goods: any = [];
  //获取用户的购买信息

  build() {
    Column() {
      //导航菜单
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
        Image($r('app.media.illustration_3x')).width(200).height(200)
        Text("购买成功！")
          .fontSize(24)
          .fontColor('#0F172A')
          .height(50)
          .lineHeight(50)
          .fontWeight(400)
        Text('请耐心等待商家发货').fontSize(16).fontColor('#64748B').height(30).lineHeight(30)
        Text('去继续购物')
          .fontSize(16)
          .fontColor('#FFFFFF')
          .backgroundColor('#059669')
          .height(60)
          .width(260)
          .borderRadius(12)
          .margin({ top: 30 })
          .textAlign(TextAlign.Center)
          .fontWeight(400)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Index',
              params: { 'type': 'goods' }
            })
          })
      }.justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
      .width('100%').height('100%')
    }.height('100%')
    .width('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }
}