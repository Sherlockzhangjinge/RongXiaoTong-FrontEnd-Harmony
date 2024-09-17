import router from '@ohos.router'
import http from '@ohos.net.http';
import promptAction from '@ohos.promptAction';
import { baseUrl } from '../api/BaseData';

@Entry
@Component
struct KnowledgeInfoPage {
  private controller: VideoController;
  @State info: any = '';
  @State pl: string = ''
  @State pls: Array<any> = []
  private scroller: Scroller = new Scroller();
  // 通过路由获取评论信息
  aboutToAppear() {
    this.info = router.getParams()['info'];
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
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
      }.height(60).width('100%').margin({ top: 10 })

      Row() {
        Text(this.info.title).fontSize(16)
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height(50)
      .alignItems(VerticalAlign.Center)
      .margin({ top: 20 })

      Row() {
        Text(`作者:${this.info.ownName}`).margin({ right: 10 }).fontSize(14)
        Text(`日期:${this.info.createTime.substring(0, 10)}`).fontSize(14)
      }
      .justifyContent(FlexAlign.End)
      .width('100%')
      .margin({ top: 10, bottom: 10 })
      .height(30)
      .alignItems(VerticalAlign.Center)

      if (this.info.picPath.lastIndexOf('.mp4') == -1) {
        Image(`${baseUrl}/file/${this.info.picPath}`)
          .width('100%')
          .height(200)
          .margin({ bottom: 10 })
      }
      if (this.info.picPath.lastIndexOf('.mp4') >= 0) {
        Video({
          src: `${baseUrl}/file/${this.info.picPath}`,
          previewUri:$r('app.media.prevideo'),
          controller: this.controller
        })
          .width('100%')
          .height(200)
          .margin({ bottom: 10 })
      }

      Row() {
        Text(this.info.content).fontSize(16).lineHeight(30)
      }.width('100%').margin({ top: 10, bottom: 10 }).layoutWeight(1).alignItems(VerticalAlign.Top)

    }
    .width('100%')
    .height('100%')
    .padding({ left: 10, right: 10 })
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }
}