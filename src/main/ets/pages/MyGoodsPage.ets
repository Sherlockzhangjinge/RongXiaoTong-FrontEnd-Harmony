import router from '@ohos.router'
import promptAction from '@ohos.promptAction';
import { deleteNeeds, getMyGoods } from '../api/GoodsApi';
import { baseUrl } from '../api/BaseData';


@Entry
@Component
struct MyGoodsPage {
  @State goodsSrc: Array<any> = [];
  @State pageNum: number = 1;
  @State type:string = ''
  private scroller: Scroller = new Scroller();

  aboutToAppear() {

    this.getGoodsPage();
  }

  getGoodsPage() {

    this.goodsSrc = [];
    this.type=router.getParams()['type']
    getMyGoods(this.type,this.pageNum).then(rst=>{
      let imageDataArray = JSON.parse(rst.result.toString()).data.list;
      for (let index = 0; index < imageDataArray.length; index++) {
        const element = imageDataArray[index];
        this.goodsSrc.push(element)
      }
    })
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Stack({ alignContent: Alignment.Start }) {
        Text(this.type=='needs'?'求购需求':'商品列表')
          .width('100%')
          .height(60)
          .fontSize(20)
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontColor(Color.Grey)
        Row() {
          Text('发布').onClick(() => {
            router.replaceUrl({ url: 'pages/ReleaseGoodsPage', params: { type: this.type=='needs'?'addNeeds':'addGoods' } })
          }).margin({ right: 10 })
        }.justifyContent(FlexAlign.End).width('100%')

        Image($r('app.media.iv_back_selected')).width(40).height(40)
          .onClick(() => {
            router.back();
          }).margin({ left: 10 })
      }.height(60).width('100%').margin({ top: 10 })

      if (this.goodsSrc.length == 0) {
        Row() {
          Text('你还没发布任何信息，请去发布吧！').fontSize(20)
            .fontColor(Color.Gray)
        }.width('100%').justifyContent(FlexAlign.Center)
        .layoutWeight(1)
      } else {
        Row() {
          Scroll(this.scroller) {
            Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
              ForEach(this.goodsSrc, (item, index) => {
                Column() {
                  Image(`${baseUrl}/file/${item.picture}`)
                    .width('100%')
                    .height(160)
                    .borderRadius(10)
                  Flex({ direction: FlexDirection.Column }) {
                    Text(`[${item.ownName}]`).margin({ right: 5 })
                    Text(`${item.content}`).height(30).lineHeight(30)
                    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
                      Text('￥' + item.price).fontColor(Color.Red).height(20).lineHeight(20)
                      Row() {
                        Text('编辑').fontSize(12).margin({ right: 5 })
                          .onClick(() => {
                            router.pushUrl({ url: 'pages/ReleaseGoodsPage', params: { type:this.type=='needs'?'editNeeds':'editGoods',info: JSON.stringify(item) } })
                          })
                        Text('删除').fontSize(12).onClick(() => {
                          AlertDialog.show({
                            title: '提示',
                            message: "你确定要删除[" + item.title + "]吗?",
                            primaryButton: {
                              value: '取消',
                              action: () => {
                              }
                            },
                            secondaryButton: {
                              value: '删除',
                              action: () => {
                                deleteNeeds(item.orderId).then(rst => {
                                  let code = JSON.parse(rst.result.toString()).code;
                                  if (code == 20000) {
                                    promptAction.showToast({
                                      message: '删除成功!',
                                      duration: 1000,
                                    });
                                    this.goodsSrc.splice(index-1, 1);
                                  } else {
                                    promptAction.showToast({
                                      message: '删除失败!',
                                      duration: 1000,
                                    });
                                  }
                                })
                              }
                            }
                          })

                        })
                      }.height(20)

                    }
                  }
                  .padding(5)
                }
                .width('47%')
                .height(260)
                .borderRadius(10)
                .backgroundColor('#ffffff')
                .opacity(0.8)
                .shadow({ radius: 5, color: Color.Gray, offsetX: 5, offsetY: 5 })
                .margin(5)
                .padding(10)
                .onClick(() => {
                  router.pushUrl({
                    url: 'pages/GoodsInfoPage',
                    params: { 'info': item }
                  })
                })
              }, item => item)
            }.width('100%')
          }.scrollable(ScrollDirection.Vertical)
          .onAppear(() => {
            // this.getGoodsPage();
            // console.info("========7777=====")
          })
          .onScrollEdge(() => {
            if (this.pageNum < globalThis.navigateLastPage) {
              this.pageNum += 1;
              this.getGoodsPage();
            }
          })
        }.width('100%')
        .layoutWeight(1)
        .alignItems(VerticalAlign.Top)
      }
    }
    .width('100%')
    .height('100%')
    .padding({ left: 10, right: 10 })
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)

  }
}