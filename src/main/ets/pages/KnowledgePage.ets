import router from '@ohos.router'
import http from '@ohos.net.http';
import { baseUrl } from '../api/BaseData';
import { getKnowledge } from '../api/KnowledgeApi';

@Entry
@Component
struct KnowledgePage {
  private controller:VideoController;
  @State knowledgeDatas: Array<any> = [];
  @State pageNum: number = 1;
  private scroller: Scroller = new Scroller();
  // 正文内容过长转省略号
  showMst(str:string){
    let msg='';
    let num=str.length;
    if(num>40){
      msg=str.substring(0,40)+"..."
    }else{
      msg=str;
    }
    return msg;
  }
  // 标题内容过长转省略号
  showTitle(str:string){
    let msg='';
    let num=str.length;
    if(num>10){
      msg=str.substring(0,10)+"..."
    }else{
      msg=str;
    }
    return msg;
  }
  // 加载农业知识数据
  loadKnowledge(){
    getKnowledge(this.pageNum).then((res)=>{
      let imageDataArray = JSON.parse(res.result.toString()).data.list;
      for (let index = 0; index < imageDataArray.length; index++) {
        const element = imageDataArray[index];
        this.knowledgeDatas.push(element)
      }
    })

  }
  aboutToAppear(){
    this.loadKnowledge()
  }
  build() {
    Flex({ direction: FlexDirection.Column }) {
      Stack({alignContent:Alignment.Start}) {
        Text('农业知识').width('100%').height(60).fontSize(20).width('100%')
          .textAlign(TextAlign.Center).fontColor(Color.Grey)
        Image($r('app.media.iv_back_selected')).width(40).height(40)
          .onClick(() => {
            router.back();
          }).margin({left:10})
      }.height(60).width('100%').margin({top:10})

      Scroll(this.scroller) {
        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
          ForEach(this.knowledgeDatas, (item, i) => {
            Row() {
              // 判断是否为视频，动态加载图片或者视频
              if (item.picPath.lastIndexOf('.mp4')==-1) {
                Image(`${baseUrl}/file/${item.picPath}`)
                  .width(100).height(100).borderRadius(5)
              }
              if(item.picPath.lastIndexOf('.mp4')>=0){
                Video({
                  src:`${baseUrl}/file/${item.picPath}`,
                  previewUri:$r('app.media.prevideo'),
                  controller: this.controller
                }).controls(false)
                  .width(100)
                  .height(100)
                  .borderRadius(5)
              }
              Flex({ direction: FlexDirection.Column }) {
                Text(`${this.showTitle(item.title)}`).fontSize(15).fontWeight(FontWeight.Bold)
                Text(`${this.showMst(item.content)}`)
                  .flexGrow(1).fontSize(13).width('70%')
                Text(`[作者:${item.ownName}]`).width('70%').textAlign(TextAlign.End).fontSize(14)
              }
              .padding(5)
              .flexGrow(1)
              .margin({left:10})
            }
            .height(120)
            .width('95%')
            .borderRadius(10)
            .backgroundColor('#ffffff')
            .padding(10)
            //.shadow({ radius: 10, color: Color.Gray, offsetX: 5, offsetY: 15 })
            .margin(5)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/KnowledgeInfoPage',
                params: { 'info': item }
              })
            })
          }, item => item)
        }.width('100%')
      }.scrollable(ScrollDirection.Vertical)
      .height('100%')
      .onScrollEdge(() => {
        this.pageNum++;
        this.loadKnowledge()
      })
    }
    .width('100%')
    .height('100%')
    .padding({ left: 10, right: 10 })
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }
}