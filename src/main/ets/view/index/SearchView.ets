import router from '@ohos.router';
import http from '@ohos.net.http';
import { baseUrl } from '../../api/BaseData';
import { getGoods, getGoodsByParam } from '../../api/GoodsApi';

@Preview
@Component
export struct SearchView {
  private scroller: Scroller = new Scroller();
  @State pageNum: number = 1;
  @State goodsSrc: Array<any> = [];
  @State word: string = '';

  getTime(str: string) {
    let date = new Date(str);
    let y = date.getFullYear();
    let m = date.getMonth() + 1;
    let d = date.getDate();
    let h = date.getHours();
    let mi = date.getMinutes();
    let msg = `${y}-${m < 10 ? '0' + m : m}-${d < 10 ? '0' + d : d} ${h}:${mi}`;
    return msg;

  }
  //获取信息
  getGoodsByParam(){
    getGoodsByParam(this.word,this.pageNum).then((res)=>{
      let imageDataArray = JSON.parse(res.result.toString()).data.list;
      for (let index = 0; index < imageDataArray.length; index++) {
        const element = imageDataArray[index];
        this.goodsSrc.push(element)
      }
    })
  }
  getAllGoods(){
    getGoods('All',this.pageNum).then((res)=>{
      let imageDataArray = JSON.parse(res.result.toString()).data.list;
      for (let index = 0; index < imageDataArray.length; index++) {
        const element = imageDataArray[index];
        this.goodsSrc.push(element)
      }
    })
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.Search_1')).width(20).height(20).margin({ left: 10 })
        TextInput({ placeholder: '搜索' })
          .onChange((val: string) => {
            this.word = val;
          }).layoutWeight(1)
          .borderWidth(0)
          .borderRadius(1)
          .backgroundColor(Color.White)
          .height(50)
          .placeholderColor(Color.Gray)
        Text('确定').margin({right:20}).onClick(() => {
          this.pageNum=1
          this.goodsSrc=[]
          if(this.word==''){
            this.getAllGoods();
          }else{
            this.getGoodsByParam();
          }
        })
      }.backgroundColor(Color.White).width('95%')
      .margin(10).borderRadius(5)


      /*供需信息*/
      Scroll(this.scroller) {
        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
          ForEach(this.goodsSrc, (item, i) => {
            Row() {
              Image(`${baseUrl}/file/${item.picture}`)
                .width(100).height(100).borderRadius(10).margin({ right: 5 })
              Flex({ direction: FlexDirection.Column }) {
                Row() {
                  Text(`[${item.type == 'goods' ? '供' : '需'}]${item.content}`)
                    .width(280)
                }.alignItems(VerticalAlign.Top)

                Text('￥' + item.price).fontColor(Color.Red).height(20).lineHeight(20).flexGrow(1)
                Row() {
                  Text(item.ownName).margin({ right: 5 }).fontSize(12)
                  Text('|').fontSize(12).margin({ left: 10, right: 10 })
                  Text(this.getTime(item.createTime)).fontSize(12)
                }
              }
              .flexGrow(1)
              .height(100)
              .padding(5)
            }
            .width('100%')
            .height(120)
            .margin(5)
            .padding(10)
            .borderRadius(10)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/GoodsInfoPage',
                params: { 'info': item }
              })
            })
            .shadow({ radius: 5, color: '#f2f2f2', offsetX: 5, offsetY: 5 })
            .backgroundColor('#ffffff')
          }, item => item)
        }.width('100%').margin({ bottom: 80 })
      }.scrollable(ScrollDirection.Vertical)
      .onAppear(() => {
        this.getAllGoods();
      })
      .onScrollEdge(() => {
        this.pageNum++;
        if(this.word==''){
          this.getAllGoods()
        }else{
          this.getGoodsByParam()
        }
      })
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.bg4'))
    .backgroundImageSize(ImageSize.Cover)
  }
}