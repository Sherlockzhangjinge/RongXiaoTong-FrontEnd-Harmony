import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { baseUrl } from '../../api/BaseData';
import { getLocation, getMyIP } from '../../api/CityApi';
import  {HttpManager} from '../../util/HttpManager'
import { RequestMethod } from '../../util/RequestOption';
@Preview
@Entry
@Component
export struct Home {
  private imageSrc: Array<any> =[]
  private scroller: Scroller = new Scroller();
  @State goodsSrc: Array<any> = [];
  @State pageNum: number = 1;
  @State cityName: string = ''
  @State word: string = '';


  //获取所有商品的信息
  getAllGoods(pn:number) {
    this.pageNum = pn
    HttpManager.getInstance()
      .request({ url: baseUrl+ "/order/All/" + this.pageNum,
        method: RequestMethod.GET })
      .then(data => {
        let imageDataArray = JSON.parse(data.result.toString()).data.list;
        for (let index = 0; index < imageDataArray.length; index++) {
          const element = imageDataArray[index];
          this.goodsSrc.push(element)
        }
        globalThis.goodsData = this.goodsSrc;
      })
      .catch(err => {
      })
  }
  //查询所有商品模糊查询
  getGoodsByParam(pn:number) {
    this.pageNum = pn;
    let url = `${baseUrl}/order/searchAllByKeys/${this.word}/${this.pageNum}`;
    if (this.word.length == 0) {
      url = `${baseUrl}/order/All/${this.pageNum}`;
    }
    console.info("=================url"+encodeURI(url))
    HttpManager.getInstance()
      .request({
        url: encodeURI(url),
        method: RequestMethod.GET,
      })
      .then(data => {
        let imageDataArray = JSON.parse(data.result.toString()).data.list;
        for (let index = 0; index < imageDataArray.length; index++) {
          const element = imageDataArray[index];
          this.goodsSrc.push(element)
        }
      })
      .catch(err => {
      })
  }
  showContent(content){
    return content.length>15?content.substring(0,15):content
  }
  showTitle(title){
    return title.length>15?title.substring(0,15):title
  }
  async aboutToAppear() {
    this.initializeImageData()
    this.getAllGoods(1);
    let resultIP = await getMyIP()
    let ip =resultIP.result.toString().replace(/\n/g, "");
    let resultLatLng = await getLocation(ip)
    let cityName = JSON.parse(resultLatLng.result.toString()).result.cityName
    this.cityName =cityName
    globalThis.lat= JSON.parse(resultLatLng.result.toString()).result.latitude
    globalThis.lng= JSON.parse(resultLatLng.result.toString()).result.longitude

  }
  initializeImageData(){
    this.imageSrc=[
      { "img": $r('app.media.banner_01') },
      { "img": $r('app.media.banner_02') },
      { "img": $r('app.media.banner_03') },
      { "img": $r('app.media.banner_04') },
      { "img": $r('app.media.banner_05') },
    ]
  }

  build() {
    Column() {
      Row() {
        Row() {
          Text(this.cityName)
            .padding({left:5})
          Text().height(35).border({ width: 1, color: '#C6C9CD' })
            .margin({ left: 5, right: 5 })
          Image($r('app.media.Search_1')).width(20).height(20).margin({ left: 10 })
          TextInput({ placeholder: '搜索' })
            .onChange((val: string) => {
              this.word = val;
            })
            .layoutWeight(1)
            .borderWidth(0)
            .borderRadius(1)
            .backgroundColor(Color.White)
            .height(50)
            .placeholderColor(Color.Gray)
          Button('确定').margin({ right: 10 }).backgroundColor(Color.Transparent).onClick(() => {
            this.goodsSrc=[]
            this.getGoodsByParam(1)
          }).fontColor(Color.Black)
        }.backgroundColor(Color.White).width('95%')
        .margin(10).borderRadius(5)
      }
      /*图片轮播*/
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Swiper() {
          ForEach(this.imageSrc, item => {
            Image(item.img).borderRadius(20)
          }, (item,index) => index.toString())
        }.autoPlay(true)
        .loop(true)
        .duration(1000)
      }.width('95%').height(150).margin({ right: 20, left: 20 })
      /*菜单*/
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Column() {
          Image($r('app.media.image')).width(70).margin({ bottom: 10 })
          Text('商品货源').fontSize(14)
        }.onClick(() => {
          router.pushUrl({
            url:'pages/GoodsPage',
            params:{
              type:'goods'
            }} )
        })

        Column() {
          Image($r('app.media.icon2')).width(70).margin({ bottom: 10 })
          Text('求购需求').fontSize(14)
        }.onClick(() => {
          router.pushUrl({
            url:'pages/GoodsPage',
            params:{
              type:'needs'
            }} )
        })

        Column() {
          Image($r('app.media.icon3')).width(70).margin({ bottom: 10 })
          Text('农业知识').fontSize(14)
        }.onClick(() => {
          router.pushUrl({url:"pages/KnowledgePage"})
        })

        Column() {
          Image($r('app.media.icon4')).width(70).margin({ bottom: 10 })
          Text('专家指导').fontSize(14)
        }.onClick(() => {
          if(globalThis.token){
            router.pushUrl({url:"pages/ExpertPage"})
          }else{
            promptAction.showToast({ message: "请先登录！", duration: 2000 })
          }
        })
      }.margin({ top: 20, bottom: 20 })
      /*供需信息*/
      if(this.goodsSrc.length>0){
        Scroll(this.scroller) {
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
            ForEach(this.goodsSrc, (item, i) => {
              Column() {
                Image(`${baseUrl}/file/${item.picture}`)
                  .height(100).width('100%')
                Column(){
                  Row(){
                    Image(item.type == 'goods' ? $r('app.media.gong') : $r('app.media.xu')).width(30).height(30)
                    Text(this.showTitle(item.title)).height(30).lineHeight(30)
                      .margin({ left:10 }).fontSize(18).fontWeight(FontWeight.Bolder)
                      .textOverflow({overflow:TextOverflow.Ellipsis})
                  }.margin({top:5})
                  Row(){
                    Text(this.showContent(item.content)).textOverflow({overflow:TextOverflow.Clip})
                      .width('100%').height(30).lineHeight(30)
                  }
                  Row(){
                    Text('￥' + item.price).fontColor(Color.Red).fontSize(18)
                    // Text(item.ownName).margin({ right: 5 }).fontSize(12)
                  }.height(20).justifyContent(FlexAlign.SpaceBetween).width('100%')
                }.layoutWeight(1).width('100%').alignItems(HorizontalAlign.Start)

              }
              .width('47%')
              .height(200)
              .borderRadius(5)
              .borderWidth(1)
              .borderColor('#ffffff')
              .margin(5)
              .padding(10)
              .onClick(()=>{
                router.pushUrl({
                  url: 'pages/GoodsInfoPage',
                  params: { 'info': item }
                })
              })
            }, item => item)
          }.width('100%')
        }
        .scrollable(ScrollDirection.Vertical)
        .height(400)
        .margin({ top: 10, right: 10, left: 10 })
        .onScrollEdge(() => {
          if(this.word == ''){
            this.getAllGoods(this.pageNum+1)
          }else{
            this.getGoodsByParam(this.pageNum+1)
          }
        })
      }else{
        Text("没有符合条件的数据")
      }
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.bg4'))
    .backgroundImageSize(ImageSize.Cover)
  }
}