import {HttpManager} from '../util/HttpManager'
import { RequestMethod } from '../util/RequestOption'
import { baseUrl } from './BaseData'


//分页获取知识列表信息
export function getKnowledge(pn:number){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/knowledge/${pn}`,
      method:RequestMethod.GET
    })
}
//专家获取知识列表信息
export function selectExpertKnowledge(){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/knowledge/selectByUsername/`,
      header:{
        Authorization:globalThis.token
      },
      method:RequestMethod.GET
    })
}
//删除知识
export function deleteKnowledge(id:string){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/knowledge/${id}`,
      method:RequestMethod.DELETE,
      header:{
        Authorization:globalThis.token
      },
      extraData:{
        knowledgeId:id
      }
    })
}
//修改知识
export function updateKnowledge(info:any){
  let a =info.pic
  console.log(info)

  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/knowledge/${info.knowledgeId}`,
      method:RequestMethod.PUT,
      header:{
        Authorization:globalThis.token
      },
      extraData:{
        content:info.content,
        knowledgeId:info.knowledgeId,
        title:info.title,
        picPath:info.picPath
      }
    })
}
//新增知识
export function releaseKnowledge(info:any){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/knowledge`,
      method:RequestMethod.POST,
      header:{
        Authorization:globalThis.token
      },
      extraData:{
        content:info.content,
        title:info.title,
        picPath:info.picPath
      }
    })
}
