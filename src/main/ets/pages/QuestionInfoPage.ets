import router from '@ohos.router'

@Preview
@Entry
@Component
struct QuestionInfoPage {
  @State info: any = ''
  // 问答内容行数 以20个字为一行
  @State qHeight: number = 0
  @State aHeight: number = 0

  aboutToAppear() {
    // 获取传过来的问答信息
    this.info = JSON.parse(router.getParams()['info']);
    // 获取行数 由于是下整除 所以需要+1
    this.qHeight = (this.info.question.length) / 20 + 1
    //判断问题有可能没有被回答的情况
    if (this.info.answer != null && this.info.answer != "") {
      this.aHeight = (this.info.answer.length) / 20 + 1
    } else {
      this.aHeight = 1
    }

  }

  build() {
    Row() {

      Column() {
        Stack({ alignContent: Alignment.Start }) {
          Text('问答信息')
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
          // 提问模块
          Column() {
            Text(`提问者(${this.info.questioner}):`)
              .fontSize(16)
              .width(300)
              .fontWeight(FontWeight.Bolder)
              .textAlign(TextAlign.End)
            Text(this.info.question).width(300).padding({ right: 20, top: 5 }).fontSize(14)
          }
          .width('90%')
          .height(35 + this.qHeight * 15)
          .border({
            radius: 12,
            width: 1,
            color: '#95a5a6'
          })
          .backgroundColor('#D3E9FF')
          .margin({ right: 5, left: 35 })
          .padding({ top: 10, right: 10 })
          // 回答模块
          Column() {
            Text(`专家(${this.info.expertName}):`)
              .fontSize(14)
              .width(300)
              .fontWeight(FontWeight.Bolder)
              .margin({ right: 10 })
              .textAlign(TextAlign.Start)
            Text(this.info.answer).width(300).padding({ right: 20, top: 5 }).fontSize(14)
          }
          .width('90%')
          .height(35 + this.aHeight * 15)
          .border({
            radius: 12,
            width: 1,
            color: '#95a5a6'
          })
          .margin({ top: 30, right: 30, bottom: 10 })
          .borderWidth(1)
          .padding({ top: 10, left: 10 })

        }.layoutWeight(1).width('100%')
      }

    }
    .height('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }
}