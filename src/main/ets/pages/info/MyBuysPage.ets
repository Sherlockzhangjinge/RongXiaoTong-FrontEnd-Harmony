/**
 * 我买的
 */
import router from '@ohos.router'
import { baseUrl } from '../../api/BaseData';
import { getMyBuys } from '../../api/CarApi';
@Preview
@Entry
@Component
struct MyBuysPage {
  @State goods:any=[];
  @State status:string[]=["",'已发货',"未发货"];
  @State colors:string[]=["","#C13AC23C","#e2c25a3a"];
  //获取用户的购买信息
  selectBuys(){
    getMyBuys().then(rst=>{
      this.goods=JSON.parse(rst.result.toString()).data;
    })
  }
  showTime(time:string){
    let end=time.indexOf(".");
    return time.substring(0,end-3).replace("T"," ");
  }
  // 商品详情
  @Builder GoodsItem(item, index) {
    Row() {
      Image(baseUrl+"/file/" + item.picture).width(90)
        .border({ width: 0.5, color: '#CFCFCF', radius: 5 })
        .margin({ top: 10, bottom: 10, right: 10 })
      Column() {
        Text("姓名:"+item.ownName).fontSize(14).fontColor('#ff323232').height('30%').fontWeight(FontWeight.Bolder)
        Text("创建日期:" + this.showTime(item.createTime)).fontSize(14).fontColor('#ff323232').height('20%')
        Text("更新日期:" + this.showTime(item.updateTime)).fontSize(14).fontColor('#ff323232').height('20%')
        Text("收货地址:"+item.address).fontSize(14).fontColor('#ff323232').height('20%')
        Blank()
        Row() {
          Text('￥' + item.totalPrice).fontSize(15).fontColor('#dc1c22')
          Blank()
          Text(this.status[item.purchaseStatus]).fontColor(this.colors[item.purchaseStatus]).fontSize(15)
        }.width('100%').margin({ top: 5 }).alignItems(VerticalAlign.Bottom)
      }
      .layoutWeight(1)
      .height('100%')
      .padding({ top: 15, bottom: 15, right: 10 })
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
    }.width('100%').height(120).backgroundColor(Color.White).margin({ bottom: 5 })
  }

  aboutToAppear(){
    this.selectBuys()
  }
  build() {
    Column(){
      //导航菜单
      Stack({alignContent:Alignment.Start}) {
        Text('我买的').width('100%').height(60).fontSize(20).width('100%')
          .textAlign(TextAlign.Center).fontColor(Color.Grey)
        Image($r('app.media.iv_back_selected')).width(40).height(40)
          .onClick(() => {
            router.back();
          }).margin({left:10})
      }.height(60).width('100%').margin({top:10}).zIndex(1)
      if(!this.goods || this.goods.length==0){
        Column() {
          Image($r('app.media.illustration_3x')).width(200).height(200)
          Text("你还没有买商品")
            .fontSize(24)
            .fontColor('#0F172A')
            .height(50)
            .lineHeight(50)
            .fontWeight(400)
          Text('快去看看吧！').fontSize(16).fontColor('#64748B').height(30).lineHeight(30)
          Text('去购物')
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
                url: 'pages/GoodsPage',
                params: { 'type': 'goods' }
              })
            })
        }.justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
        .width('100%').height('100%')
      }else{
        List() {
          ForEach(this.goods, (item, index) => {
            ListItem() {
              this.GoodsItem(item, index)
            }
          }, item => JSON.stringify(item))
        }.layoutWeight(1)
      }
    }.height('100%')
    .width('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }
}