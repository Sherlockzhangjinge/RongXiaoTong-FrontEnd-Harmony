import {HttpManager} from '../util/HttpManager'
import { RequestMethod } from '../util/RequestOption'
import { baseUrl } from './BaseData'


//获取我的问答信息
export function getMyQuestion(){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/question/selectByKind/questioner`,
      method:RequestMethod.GET,
      header:{
        Authorization:globalThis.token
      }
    })
}
//获取专家问答信息
export function getExpertQuestion(){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/question/selectByKind/expert`,
      method:RequestMethod.GET,
      header:{
        Authorization:globalThis.token
      }
    })
}
//删除问答信息
export function deleteQuestion(id:string){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/question/delete/${id}`,
      method:RequestMethod.DELETE,
      header:{
        Authorization:globalThis.token
      }
    })
}
//更新问答信息
export function updateQuestion(item:any){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/question/update`,
      method:RequestMethod.PUT,
      header:{
        Authorization:globalThis.token
      },
      extraData:{
        answer:item.answer,
        expertName:item.expertName,
        phone:item.phone,
        plantName:item.plantName,
        id:item.id,
        question:item.question,
        questioner:item.questioner,
        status:1,
        title:item.title
      }
    })
}