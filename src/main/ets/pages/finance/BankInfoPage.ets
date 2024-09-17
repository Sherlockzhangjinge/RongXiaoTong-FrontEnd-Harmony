import router from '@ohos.router';
import http from '@ohos.net.http';
import { baseUrl } from '../../api/BaseData';
import { HttpManager } from '../../util/HttpManager';
import { RequestMethod } from '../../util/RequestOption';
import {financeApi} from '../../api/FinanceApi';

@Preview
@Entry
@Component
struct BankInfoPage {
  @State bank: any = {};
  @State bankIds: any = [];

  getMyFinanceBankId() {
    financeApi().then(data => {
      this.bankIds = [];
      let datas = JSON.parse(data.result.toString()).data;
      for (let d of datas) {
        this.bankIds.push("[" + d.bankId + "]");
      }
    })
  }

  aboutToAppear() {
    this.bank = router.getParams()['info'];
    this.getMyFinanceBankId();
  }

  build() {
    Row() {
      Column() {
        Stack({ alignContent: Alignment.Start }) {
          Text(this.bank.bankName)
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
          Text("     " + this.bank.introduce).fontSize(16).lineHeight(30)
        }.layoutWeight(1).width('100%').alignItems(VerticalAlign.Top)
        .padding(10)

        Column() {
          Text('请选择贷款方式').width('100%').textAlign(TextAlign.Start)
          Row() {
            if (this.bankIds.indexOf("[" + this.bank.bankId + "]") == -1) {
              Button('个人贷款').margin({ right: 10 }).onClick(() => {
                router.pushUrl({ url: 'pages/finance/PersonalLoansPage', params: { info: this.bank } })
              })
              Button('组合贷款').onClick(() => {
                router.pushUrl({ url: 'pages/finance/PortfolioLoansPage', params: { info: this.bank } })
              })
            } else {
              Text("已申贷款")
                .backgroundColor("#f3d19e")
                .fontColor("#ffffff")
                .width(96)
                .height(40)
                .borderRadius(10)
                .textAlign(TextAlign.Center)
            }
          }.width('100%').justifyContent(FlexAlign.Center)
          .height(60).alignItems(VerticalAlign.Center)
        }.padding(10)
      }
      .width('100%')
    }
    .height('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }
}