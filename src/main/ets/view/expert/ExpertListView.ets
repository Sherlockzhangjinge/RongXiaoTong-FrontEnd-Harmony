import http from '@ohos.net.http';
import router from '@ohos.router';
import { baseUrl } from '../../api/BaseData';
import { getExpertList } from '../../api/ExpertApi'

@Component
export struct ExpertListView {
  @State str: string = ''
  @State wdList: Array<any> = []
  @State page: number = 1;

  getExpert() {
    getExpertList(this.page).then((res) => {
      this.wdList = JSON.parse(res.result.toString()).data.list;
    })

  }

  aboutToAppear() {
    this.getExpert()
  }

  build() {
    Column() {
      Column() {
        List() {
          ForEach(this.wdList, (item, index) => {
            ListItem() {
              Row() {
                Image($r('app.media.experta')).width(80).width(80).margin({ right: 10 })
                Column() {
                  Text('专家姓名: ' + item.realName).fontSize(14).margin({ bottom: 15 })
                  Blank()
                  Text('职称: ' + item.position).fontSize(12).margin({ bottom: 10 })
                  Blank()
                  Text('从事专业: ' + item.profession).fontSize(12).margin({ bottom: 10 })
                  Blank()
                  Text('联系电话: ' + item.phone).fontSize(12).margin({ bottom: 10 })
                  Blank()
                  Text('单位: ' + item.belong).fontSize(12).margin({ bottom: 10 })
                  Blank()
                }.height('100%').alignItems(HorizontalAlign.Start)

                Blank()
                Column() {
                  Blank()
                  Text('向我提问').fontSize(14).onClick(() => {
                    router.pushUrl({ url: 'pages/expert/ExpertQuestionPage', params: { name: item.userName } })
                  })
                  Blank()
                  Text('线下预约').fontSize(14).onClick(() => {
                    router.pushUrl({ url: 'pages/expert/ExpertReservePage', params: { name: item.userName } })
                  })
                  Blank()
                }.height('100%').alignItems(HorizontalAlign.Start)
              }.padding({ left: 20, right: 20, bottom: 20, top: 20 })
              .width('100%').height(150)
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