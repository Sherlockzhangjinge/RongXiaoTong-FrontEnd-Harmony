 import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { searchExpert, updateExpert } from '../../../api/ExpertApi'
@Preview
@Entry
@Component
struct SearchExpertInfoPage {
  @State expert: any = {}

  searchExpert() {
    searchExpert().then(rst => {
      console.info("================searchExpert",rst.result.toString())
      this.expert = JSON.parse(rst.result.toString()).data
    })
  }
  updateExpert(){
    updateExpert(this.expert).then(rst=>{
      let data=JSON.parse(rst.result.toString());
      promptAction.showToast({message:data.message,duration:2000})
    })
  }

  aboutToAppear(){
    this.searchExpert();
  }
  build() {
    Column() {
      Stack({ alignContent: Alignment.Start }) {
        Text('专家信息')
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
        List() {
          ListItem() {
            Row() {
              Text('真实姓名:').width(100)
              TextInput({text:this.expert.realName}).onChange(v=>{
                this.expert.realName=v;
              }).borderRadius(5).height(40).width(250)
            }.width('100%')
          }.padding({ left: 20, right: 20 }).height(80)

          ListItem() {
            Row() {
              Text('手机号码:').width(100)
              TextInput({text:this.expert.phone}).onChange(v=>{
                this.expert.phone=v;
              }).borderRadius(5).height(40).width(250)
            }.width('100%')
          }.padding({ left: 20, right: 20 }).height(80)

          ListItem() {
            Row() {
              Text('从事专业:').width(100)
              TextInput({text:this.expert.profession}).onChange(v=>{
                this.expert.profession=v;
              }).borderRadius(5).height(40).width(250)
            }.width('100%')
          }.padding({ left: 20, right: 20 }).height(80)

          ListItem() {
            Row() {
              Text('职位:').width(100)
              TextInput({text:this.expert.position}).onChange(v=>{
                this.expert.position=v;
              }).borderRadius(5).height(40).width(250)
            }.width('100%')
          }.padding({ left: 20, right: 20 }).height(80)
          ListItem() {
            Row() {
              Text('所属单位:').width(100)
              TextInput({text:this.expert.belong}).onChange(v=>{
                this.expert.belong=v;
              }).borderRadius(5).height(40).width(250)
            }.width('100%')
          }.padding({ left: 20, right: 20 }).height(80)
        }.height('100%')
      }.width("100%")
      //.layoutWeight(1)
      .height('100%')

      Row() {
        Button("修改").width(100).borderRadius(5).onClick(()=>{
          this.updateExpert()
        })
      }.width('100%').justifyContent(FlexAlign.Center)
      .margin({top:-200})
    }.width('100%').height('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }
}