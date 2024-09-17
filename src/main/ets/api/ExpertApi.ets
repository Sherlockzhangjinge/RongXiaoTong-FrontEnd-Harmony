import {HttpManager} from '../util/HttpManager'
import { RequestMethod } from '../util/RequestOption'
import { baseUrl } from './BaseData'
//获取问答信息
export function getQuestionList(pn:number){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/question/findAllQues/${pn}`,
      method:RequestMethod.GET,
      header:{
        Authorization:globalThis.token
      }
    })
}


//获取专家信息
export function getExpertList(pn:number){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/question/findExpert/${pn}`,
      method:RequestMethod.GET,
      header:{
        Authorization:globalThis.token
      }
    })
}

//创建问题
export function addQuestion(info:any){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/question/add`,
      method:RequestMethod.POST,
      header:{
        Authorization:globalThis.token
      },
      extraData:{
        expertName:info.expertName,
        phone:info.phone,
        isDefault:info.isDefault,
        plantName:info.plantName,
        question:info.question,
        status:0,
        title:info.title
      }
    })
}

//创建线下预约
export function addReserve(info:any){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/reserve/add`,
      method:RequestMethod.POST,
      header:{
        Authorization:globalThis.token
      },
      extraData:{
        address:info.address,
        area:info.area,
        expertName:info.expertName,
        phone:info.phone,
        plantCondition:info.plantCondition,
        plantDetail:info.plantDetail,
        plantName:info.plantName,
        soilCondition:info.soilCondition,
        status:0
      }
    })
}
//获取我的预约信息
export function getMyReserve(){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/reserve/selectByKind/questioner`,
      method:RequestMethod.GET,
      header:{
        Authorization:globalThis.token
      }
    })
}
//获取专家预约信息
export function findExpertReserveAll(){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/reserve/selectByKind/expert`,
      method:RequestMethod.GET,
      header:{
        Authorization:globalThis.token
      }
    })
}
//删除预约信息
export function deleteExpertReserve(id:string){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/reserve/delete/${id}`,
      method:RequestMethod.GET,
      header:{
        Authorization:globalThis.token
      }
    })
}
//更新预约信息
export function updateReserve(item:any){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/reserve/update`,
      method:RequestMethod.PUT,
      header:{
        Authorization:globalThis.token
      },
      extraData:{
        id:item.id,
        expertName:item.expertName,
        questioner:item.questioner,
        area:item.area,
        address:item.address,
        plantName:item.plantName,
        soilCondition:item.soilCondition,
        plantCondition:item.plantCondition,
        plantDetail:item.plantDetail,
        phone:item.phone,
        message:item.message,
        answer:item.answer,
        status:item.status
      }
    })
}
//获取专家信息
export function searchExpert(){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/user/searchexpert`,
      method:RequestMethod.GET,
      header:{
        Authorization:globalThis.token
      }
    })
}
//更新专家信息
export function updateExpert(expert:any){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/user/addUpdexpert`,
      method:RequestMethod.POST,
      header:{
        Authorization:globalThis.token
      },
      extraData:{
        belong:expert.belong,
        phone:expert.phone,
        position:expert.position,
        profession:expert.profession,
        realName:expert.realName,
        userName:expert.userName
      }
    })
}