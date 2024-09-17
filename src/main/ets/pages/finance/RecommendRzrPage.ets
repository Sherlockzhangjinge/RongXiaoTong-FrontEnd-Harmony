/**
 * 智能匹配页面
 */
import router from '@ohos.router'
import promptAction from '@ohos.promptAction';
import { addIntention, deleteIntention, getAllRecommendUsers, getIntentions, updateIntention } from '../../api/FinanceApi';
import { baseUrl } from '../../api/BaseData';

@Preview
@Entry
@Component
struct RecommendRzrPage {
  @State recommendusers:Array<any>=[]
  @State hasIntention: boolean = false;
  @State token: string = '';
  //我的融资
  @State intention: any = {}
  @State isShow: boolean = false
  @State qiXians: Array<string> = ['6', '12', '24', '36']
  @State years: Array<string> = ['六个月', '一年', '二年', '三年']
  //获取取融资意向
  getIntentions() {
    this.intention = {}
    getIntentions().then(rst=>{
      let imageDataArray = JSON.parse(rst.result.toString()).data;
      if (imageDataArray.length>0) {
        this.intention = imageDataArray[0];
        this.hasIntention = true
      }


    })
  }
  //推荐融资人
  getAllRecommendUsers() {
    this.recommendusers = []
    getAllRecommendUsers().then(rst=>{
      let imageDataArray = JSON.parse(rst.result.toString()).data;
      for (let index = 0; index < imageDataArray.length; index++) {
        let item = imageDataArray[index];
        this.recommendusers.push(item)
      }
    })
  }

  //修改融资意向
  updateIntention() {
    updateIntention(this.intention).then(rst=>{
      let data = JSON.parse(rst.result.toString());
      promptAction.showToast({
        message: data.message,
        duration: 1000,
      });
      if (data.code == 20000) {
        this.isShow = false
      }
    })
  }
  //添加融资意向
  addIntention() {
    addIntention(this.intention).then(rst=>{
      let data = JSON.parse(rst.result.toString())
      promptAction.showToast({
        message: data.message,
        duration: 1000,
      });
      setTimeout(()=>{
        router.back()
      },2000)
    })
  }
  //删除融资信息
  deleteIntention() {
    deleteIntention().then(rst=>{
      let data = JSON.parse(rst.result.toString())
      promptAction.showToast({
        message: data.message,
        duration: 1000,
      });
      if (data.code == 20000) {
        this.getAllRecommendUsers();
        //把融资信息清空
        this.intention={}
        this.isShow = false
      }
    })
    this.hasIntention = false
  }

  aboutToAppear() {
    this.token = globalThis.token;
    this.getAllRecommendUsers();
    this.getIntentions();
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Stack({ alignContent: Alignment.Start }) {
        Text('推荐融资人')
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
        ForEach(this.recommendusers, (item, index) => {
          ListItem() {
            Row() {
              Image(baseUrl+"/file/" + item.avatar)
                .width(120).height(120).borderRadius(10)
                .margin(10)
              Column() {
                Text("姓名:" + item.realName).margin(3)
                Text("联系方式:" + item.phone).margin(3)
                Text("地址:" + item.address).margin(3)
                Text("农作物:" + item.item).margin(3)
                Row() {
                  Text("金额:" + (item.amount == -1 ? '-' : item.amount) + "元")
                    .margin({ right: 20 })
                  Text("种植面积:" + (item.area == -1 ? '-' : item.area) + "亩")
                }.margin(3)
              }.alignItems(HorizontalAlign.Start)
            }
            .borderWidth(1)
            .borderRadius(10)
            .borderColor(Color.Grey)
            .margin(10)
            .width('95%')
          }
        }, (item, index) => item + index)
      }.margin({ top: 60, bottom: 60 })

      Stack({ alignContent: Alignment.Bottom }) {
        Button(!this.hasIntention ? '添加融资意向' : '我的融资意向')
          .fontColor(Color.White)
          .backgroundColor(Color.Red)
          .type(ButtonType.Normal)
          .width('95%')
          .borderRadius(10)
          .margin({ bottom: 10 })
          .onClick(() => {
            this.isShow = true;
          })
      }.width('100%').height('100%').zIndex(-1)

      //显示融资意向
      Panel(this.isShow) {
        Column() {
          Text('我的融资意向').margin({ top: 10, bottom: 20 })

          Row() {
            Text('姓名:').width(90).textAlign(TextAlign.End)
            TextInput({ text: this.intention.realName }).onChange((v) => {
              this.intention.realName = v;
            }).width(280).margin({ left: 10 }).borderRadius(5)
          }.margin({ bottom: 20 }).width('100%')


          Row() {
            Text('联系方式:').width(90).textAlign(TextAlign.End)
            TextInput({ text: this.intention.phone ? this.intention.phone + '' : '' }).onChange((v) => {
              this.intention.phone = v;
            }).width(280).margin({ left: 10 }).borderRadius(5)
          }.margin({ bottom: 20 }).width('100%')


          Row() {
            Text('金额:').width(90).textAlign(TextAlign.End)
            TextInput({ text: this.intention.amount ? this.intention.amount + '' : '' }).onChange((v) => {
              this.intention.amount = v;
            }).width(200).margin({ left: 10 }).borderRadius(5)
            Text("单位：元")
          }.margin({ bottom: 20 }).width('100%')


          Row() {
            Text('用途:').width(90).textAlign(TextAlign.End)
            TextInput({ text: this.intention.application }).onChange((v) => {
              this.intention.application = v;
            }).width(280).margin({ left: 10 }).borderRadius(5)
          }.margin({ bottom: 20 }).width('100%')


          Row() {
            Text('农作物名称:').width(90).textAlign(TextAlign.End)
            TextInput({ text: this.intention.item }).onChange((v) => {
              this.intention.item = v;
            }).width(280).margin({ left: 10 }).borderRadius(5)
          }.margin({ bottom: 20 }).width('100%')


          Row() {
            Text('种植面积:').width(90).textAlign(TextAlign.End)
            TextInput({ text: this.intention.area ? this.intention.area + '' : '' }).onChange((v) => {
              this.intention.area = v;
            }).width(200).margin({ left: 10 }).borderRadius(5)
            Text("单位：亩")
          }.margin({ bottom: 20 }).width('100%')


          Row() {
            Text('意向借款期:').width(90).textAlign(TextAlign.End)
            Select([{ value: '六个月' }, { value: '一年' }, { value: '二年' }, { value: '三年' }])
              .value(!this.intention.repaymentPeriod ? '请选择意向借款期' : this.years[parseInt(this.intention.repaymentPeriod / 12 + '')])
              .onSelect((index: number) => {
                this.intention.repaymentPeriod = this.qiXians[index];
              })
              .width(200)
              .margin({ left: 10 })
              .borderRadius(5)
            Text('单位：月')
          }.margin({ bottom: 20 }).width('100%')


          Row() {
            Text('地址:').width(90).textAlign(TextAlign.End)
            TextInput({ text: this.intention.address }).onChange((v) => {
              this.intention.address = v;
            }).width(280).margin({ left: 10 }).borderRadius(5)
          }.margin({ bottom: 20 }).width('100%')


          Row() {
            if (!this.hasIntention) {
              Button('确定').type(ButtonType.Normal).borderRadius(5).margin({ right: 20 }).onClick(() => {
                this.addIntention();
              })
            }
            else {
              Button('编辑').type(ButtonType.Normal).borderRadius(5).margin({ right: 20 }).onClick(() => {
                this.updateIntention();
              })
              Button('删除').type(ButtonType.Normal).backgroundColor(Color.Red).borderRadius(5).margin({ right: 20 }).onClick(() => {
                this.deleteIntention();
              })
            }
            Button('取消').type(ButtonType.Normal).backgroundColor(Color.Grey).onClick(() => {
              this.isShow = false;
            })
          }.width('100%').justifyContent(FlexAlign.Center)
        }

      }
      .type(PanelType.Foldable)
      .mode(PanelMode.Half)
      .dragBar(true) // 默认开启
      .halfHeight(580) // 默认一半
    }.height('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }
}