import router from '@ohos.router'
import http from '@ohos.net.http';
import promptAction from '@ohos.promptAction';
import { baseUrl } from '../api/BaseData';
import { addAddress, editAddress } from '../api/AddressApi';
@Entry
@Component
struct EditAddressPage {
  @State item:any={};
  @State type:string=''
  @State title:string = '编辑收货地址'

  aboutToAppear(){
    let type = router.getParams()['type']
    this.type = type
    if(type=='edit'){
      this.item=JSON.parse(router.getParams()['address'])
    }else{
      this.title='新建收货地址'
    }

  }
  build() {
    Row() {
      Column() {
        Stack({alignContent:Alignment.Start}) {
          Text(this.title).width('100%').height(60).fontSize(20).width('100%')
            .textAlign(TextAlign.Center).fontColor(Color.Grey)
          Row(){
            if(this.type=='edit'){
              Text('删除').onClick(()=>{
                AlertDialog.show({
                  title: '提示',
                  message: "你确定要删除该地址吗？",
                  primaryButton: {
                    value: '取消',
                    action: () => {

                    }
                  },
                  secondaryButton:{
                    value:'删除',
                    action:()=>{
                      let url=baseUrl +'/address/delete/'+this.item.id;
                      let httpRequest=http.createHttp();
                      httpRequest.request(url,{
                        method:http.RequestMethod.DELETE,
                        header:{
                          Authorization:globalThis.token
                        }
                      },(err,data)=>{
                        if(!err){
                          let code=JSON.parse(data.result.toString()).code;
                          if(code==20000){
                            promptAction.showToast({
                              message: '删除成功!',
                              duration: 1000,
                            });
                            setTimeout(()=>{
                              router.replaceUrl({url:'pages/ShowAddressPage'})
                            },1000)
                          }else{
                            promptAction.showToast({
                              message: '删除失败!',
                              duration: 2000,
                            });
                          }
                        }
                      })
                    }
                  }
                })
              }).margin({right:10})
            }

          }.justifyContent(FlexAlign.End).width('100%')
          Image($r('app.media.iv_back_selected')).width(40).height(40)
            .onClick(() => {
              router.back();
            }).margin({left:10})
        }.height(60).width('100%').margin({top:10})

        Column(){
          //基本信息
          List(){
            ListItem(){
              Row(){
                Text('收货人:').width(100)
                TextInput({text:this.item.consignee}).onChange((val)=>{
                  this.item.consignee=val
                }).borderWidth(0).backgroundColor(Color.Transparent)
              }
            }.padding({left:20,right:20}).height(60)
            ListItem(){
              Row(){
                Text('收货地址:').width(100)
                TextInput({text:this.item.addressDetail}).onChange((val)=>{
                  this.item.addressDetail=val
                }).borderWidth(0).backgroundColor(Color.Transparent)
              }
            }.padding({left:20,right:20}).height(60)
            ListItem(){
              Row(){
                Text('手机号码:').width(100)
                TextInput({text:this.item.phone}).onChange((val)=>{
                  this.item.phone=val
                }).borderWidth(0).backgroundColor(Color.Transparent)
              }
            }.padding({left:20,right:20}).height(60)
          }.divider({ strokeWidth: 1, color: '#f1f1f1', startMargin: 20, endMargin: 20 }) // 每行之间的分界线
          .borderRadius(10)
          .margin(5)
          .backgroundColor('#ffffff')
          //设置为默认值
          Column(){
            Row(){
              Column(){
                Text('设置为默认地址').height(60)
                Text('提醒:下单会优先使用该地址').fontSize(12).fontColor('rgba(0,0,0,0.4)').height(30)
              }.alignItems(HorizontalAlign.Start)
              Column(){
                Toggle({ type: ToggleType.Switch, isOn: this.item.isDefault })
                  .selectedColor(Color.Red)
                  .switchPointColor(0xe5ffffff)
                  .onChange((flag: boolean) => {
                    this.item.isDefault=flag
                  })
              }
            }.width("100%").justifyContent(FlexAlign.SpaceBetween)

          } .borderRadius(10)
          .margin(5)
          .backgroundColor('#ffffff')
          .padding({left:20,right:20})
        }.layoutWeight(1)
        Row(){
          Button("保存").fontColor(Color.White).backgroundColor(Color.Red)
            .type(ButtonType.Normal)
            .width('100%')
            .borderRadius(20)
            .onClick(()=>{
              //验证格式
              let p=/^1[3-9][0-9]{9}$/;
              if(!p.test(this.item.phone)){
                promptAction.showToast({
                  message: '手机号码输入有误!',
                  duration: 2000,
                });
                return;
              }
              // 判断是否有数据（是否为编辑地址）
              if(this.type=='edit'){
                // 发送请求
                editAddress({
                  addressDetail:this.item.addressDetail,
                  consignee:this.item.consignee,
                  isDefault:this.item.isDefault,
                  phone:this.item.phone,
                  id:this.item.id
                }).then((res)=>{
                  let code=JSON.parse(res.result.toString()).code;
                  if(code==20000){
                    promptAction.showToast({
                      message: '修改成功!',
                      duration: 1000,
                    });
                    setTimeout(()=>{
                      router.replaceUrl({url:'pages/ShowAddressPage'})
                    },1000)
                  }else{
                    promptAction.showToast({
                      message: '修改失败!',
                      duration: 2000,
                    });
                  }
                })
              }else{
                // 添加状态 调用添加地址方法
                addAddress({
                  addressDetail:this.item.addressDetail,
                  consignee:this.item.consignee,
                  isDefault:this.item.isDefault,
                  phone:this.item.phone
                }).then((res)=>{
                  let code=JSON.parse(res.result.toString()).code;
                  if(code==20000){
                    promptAction.showToast({
                      message: '添加成功!',
                      duration: 1000,
                    });
                    setTimeout(()=>{
                      router.replaceUrl({url:'pages/ShowAddressPage'})
                    },1000)
                  }else{
                    promptAction.showToast({
                      message: '添加失败!',
                      duration: 2000,
                    });
                  }
                })
              }
            })
        }.alignItems(VerticalAlign.Bottom).padding(10).backgroundColor('#ffffff')
        .width('100%')
      }
      .width('100%')
    }
    .height('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }
}