/**
 * 智能匹配页面
 */
import router from '@ohos.router'
import { getQuestionList } from '../../api/ExpertApi';
import { getMyQuestion } from '../../api/QuestionApi';

@Preview
@Entry
@Component
struct MyWenDaPage {
  @State isShow: boolean = false
  @State questionList: any = [];
  @State question: any = {}

  findMyQuestion() {
    getMyQuestion().then((res)=>{
      this.questionList=JSON.parse(res.result.toString()).data;

    })
  }

  aboutToAppear() {
    this.findMyQuestion()
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
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

      List() {
        ForEach(this.questionList, (item, index) => {
          ListItem() {
            Row() {
              Column() {
                Text(item.title).margin(3).fontWeight(FontWeight.Bolder)
                Text(item.question).margin(3)
                Text("专家名称:" + item.expertName).margin(3)
                if (item.status == 0) {
                  Text('未回答').backgroundColor('#fef0f0').fontColor('#f56c6c').margin(3).padding(5)
                } else {
                  Text('已回答').backgroundColor('#409eff').fontColor('#f5f7fa').margin(3).padding(5)
                }
              }.alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              Row() {
                Text("详情").margin({ right: 10 }).onClick(() => {
                  this.isShow = true;
                  this.question = item;
                })
                // if (item.status == 0) {
                //   Text("修改").margin({ right: 10 }).onClick(() => {
                //     router.replaceUrl({url:'pages/info/EditMyQuestionaPage',params:{wenda:JSON.stringify(item)}})
                //   })
                // }
              }
            }
            .borderWidth(1)
            .borderRadius(10)
            .borderColor(Color.Grey)
            .margin(10)
            .padding(10)
            .width('95%')
          }
        }, (item, index) => item + index)
      }.margin({ top: 60, bottom: 60 })
      //显示问答信息
      Panel(this.isShow) {
        Column() {
          Text('详情').margin({ top: 10, bottom: 20 })
          Row() {
            Text('问题标题:').width(90).textAlign(TextAlign.End)
            Text(this.question.title)
          }.margin({ bottom: 20 }).width('100%')
          Row() {
            Text('问题内容:').width(90).textAlign(TextAlign.End)
            Text(this.question.question).width(300)
          }.margin({ bottom: 20 }).width('100%')
          Row() {
            Text('专家姓名:').width(90).textAlign(TextAlign.End)
            Text(this.question.expertName)
          }.margin({ bottom: 20 }).width('100%')
          // if(this.question.answer){
          Row() {
            Text('回答内容:').width(90).textAlign(TextAlign.End)
            Text(this.question.answer).width(300)
          }.margin({ bottom: 20 }).width('100%')
          // }
          Row() {
            Text('问题状态:').width(90).textAlign(TextAlign.End)
            if (this.question.status == 0) {
              Text('未回答').backgroundColor('#fef0f0').fontColor('#f56c6c').margin(3).padding(5)
            } else {
              Text('已回答').backgroundColor('#409eff').fontColor('#f5f7fa').margin(3).padding(5)
            }
          }.margin({ bottom: 20 }).width('100%')
          Row() {
            Button('取消').type(ButtonType.Normal).onClick(() => {
              this.isShow = false;
            })
          }.width('100%').justifyContent(FlexAlign.Center)
        }
      }
      .type(PanelType.Foldable)
      .mode(PanelMode.Half)
      .dragBar(true) // 默认开启
      .halfHeight(300) // 默认一半
    }
    .height('100%')
    .width('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }
}