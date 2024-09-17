import router from '@ohos.router';
import { getQuestionList } from '../../api/ExpertApi';

@Component
export struct QuestionListView {
  @State wdList: Array<any> = []
  @State page: number = 1;
  // 获取问答信息，并渲染到界面中
  getQuestionList() {
    getQuestionList(this.page).then((res) => {
      this.wdList = JSON.parse(res.result.toString()).data.list;
    })
  }

  aboutToAppear() {
    this.getQuestionList()
  }

  build() {
    Column() {
      Column() {
        List() {
          ForEach(this.wdList, (item, index) => {
            ListItem() {
              Column() {
                Row() {
                  // 通过状态判断显示文还是答
                  Text(item.status == 0 ? '[问]' : '[答]')
                  Text(item.title)
                }.width('100%')
                .justifyContent(FlexAlign.Start)
                // 显示问答人名称
                Row() {
                  Text('提问者:' + item.questioner).fontSize(12).margin({ right: 10 })
                  Text('专家:' + item.expertName).fontSize(12)
                }.width('100%')
                .justifyContent(FlexAlign.End)
              }.padding({ left: 20, right: 20, bottom: 20, top: 20 })
              .width('100%')
              .onClick(() => {
                router.pushUrl({ url: "pages/QuestionInfoPage", params: { info: JSON.stringify(item) } })
              })
            }
          }, item => item)
        }.divider({ strokeWidth: 1, color: '#f1f1f1', startMargin: 20, endMargin: 20 }) // 每行之间的分界线
        .borderRadius(10)
        .margin(5)
        .backgroundColor('#ffffff')
      }.layoutWeight(1).width('100%')
    }
  }
}