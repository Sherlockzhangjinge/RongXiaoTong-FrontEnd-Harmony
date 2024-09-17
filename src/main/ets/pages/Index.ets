import { CarInfo } from '../view/index/CarInfoView';
import { Home } from '../view/index/HomeView'
import { MyInfo } from '../view/index/MyInfo';
import { SearchView } from '../view/index/SearchView';

@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController()
  @Builder TabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 24, height: 24 })
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? '#059669' : '#94A3B8')
        .margin({ top: $r('app.float.tab_text_margin_top') })
        .fontSize(12)
        .fontFamily("宋体")
    }
    .width('100%')
    .height(60)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex;
      this.tabsController.changeIndex(this.currentIndex);
    })
  }

  build() {
    Column() {
      Tabs({
        index: this.currentIndex,
        barPosition: BarPosition.End
      }) {
        TabContent() {
          Home()
        }
        .tabBar(this.TabBuilder('首页', 0, $r('app.media.home3'), $r('app.media.home1')))

        TabContent() {
          if (this.currentIndex == 1) {
            SearchView()
          }
        }
        .tabBar(this.TabBuilder('搜索', 1, $r('app.media.Search_3'), $r('app.media.Search_1')))

        TabContent() {
          if (this.currentIndex == 2) {
            CarInfo()
          }
        }
        .tabBar(this.TabBuilder('购物车', 2, $r('app.media.Bag'), $r('app.media.Bag2_3x')))

        TabContent() {
          if(this.currentIndex==3){
            MyInfo()
          }
        }
        .tabBar(this.TabBuilder('我的', 3, $r('app.media.user_3'), $r('app.media.user_1')))
      }.onChange((index) => {
        this.currentIndex = index
      }).barHeight(56)
    }
    .width('100%')
    .width('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }
}