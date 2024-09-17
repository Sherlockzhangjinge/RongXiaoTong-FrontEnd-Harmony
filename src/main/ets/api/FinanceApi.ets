import http from '@ohos.net.http'
import {HttpManager} from '../util/HttpManager'
import { RequestMethod } from '../util/RequestOption'
import { baseUrl } from './BaseData'
//获取融资意向
export function getIntentions(){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/finance/selectIntentionByName`,
      method:RequestMethod.GET,
      header:{
        Authorization:globalThis.token
      }
    })
}
//获取推荐融资人
export function getAllRecommendUsers(){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/finance/selectRecommendByName`,
      method:RequestMethod.GET,
      header:{
        Authorization:globalThis.token
      }
    })
}
//添加融资信息
export function addIntention(intention){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/finance/insertIntentionByName`,
      method:RequestMethod.POST,
      header:{
        Authorization:globalThis.token
      },
      extraData: {
        address: intention.address,
        amount: intention.amount,
        application: intention.application,
        area: intention.area,
        item: intention.item,
        phone: intention.phone,
        realName: intention.realName,
        repaymentPeriod: intention.repaymentPeriod
      }
    })
}
//修改融资信息
export function updateIntention(intention){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/finance/updateIntentionByName`,
      method:RequestMethod.PUT,
      header:{
        Authorization:globalThis.token
      },
      extraData: {
        address: intention.address,
        amount: intention.amount,
        application: intention.application,
        area: intention.area,
        item: intention.item,
        phone: intention.phone,
        realName: intention.realName,
        repaymentPeriod: intention.repaymentPeriod
      }
    })
}
//删除融资信息
export function deleteIntention(){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/finance/deleteIntentionByName`,
      method:RequestMethod.DELETE,
      header:{
        Authorization:globalThis.token
      }
    })
}
// 获取银行信息
export function getShowBank(){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/finance/selectbank`,
      method:RequestMethod.GET,
      header:{
        Authorization:globalThis.token
      }
    })
}
// 添加融资信息
export function financeAdd(item:any){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/finance/add`,
      method:RequestMethod.POST,
      header:{
        Authorization:globalThis.token
      },
      extraData: {
        bankId: item.bankId,
        fileInfo:item.fileInfo,
        idNum: item.idNum,
        money: item.money,
        phone: item.phone,
        rate: item.rate,
        realName: item.realName,
        repayment: item.repayment
      }
    })
}
export function financeApi(){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/finance/selectIntentionByName`,
      method:RequestMethod.GET,
      header:{
        Authorization:globalThis.token
      }
    })
}

// 添加组合贷款信息
export function addFinanceMulti(info:any){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/finance/addFinanceMulti`,
      method:RequestMethod.POST,
      header:{
        Authorization:globalThis.token
      },
      extraData:{
        bankId:info.bankId,
        combinationIdnum1:info.combinationIdnum1,
        combinationIdnum2:info.combinationIdnum2,
        combinationName1:info.combinationName1,
        combinationName2:info.combinationName2,
        combinationPhone1:info.combinationPhone1,
        combinationPhone2:info.combinationPhone2,
        fileInfo:info.fileInfo,
        idNum:info.idNum,
        money:info.money,
        phone:info.phone,
        rate:info.rate,
        realName:info.realName,
        repayment:info.repayment
      }
    })
}
// 获取个人融资贷款信息
export function getMyFinance(){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/finance/selectByName/`,
      method:RequestMethod.GET,
      header:{
        Authorization:globalThis.token
      }
    })
}
// 修改个人融资贷款信息
export function updateFinanceInfo(item:any){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/finance/update/`,
      method:RequestMethod.PUT,
      header:{
        Authorization:globalThis.token
      },
      extraData: {
        combinationIdnum1: item.combinationIdnum1,
        combinationIdnum2: item.combinationIdnum2,
        combinationName1: item.combinationName1,
        combinationName2: item.combinationName2,
        combinationPhone1: item.combinationPhone1,
        combinationPhone2: item.combinationPhone2,
        financeId: item.financeId,
        idNum: item.idNum,
        money: item.money,
        phone: item.phone,
        rate: item.rate,
        realName: item.realName,
        repayment: item.repayment
      }
    })
}
// 删除个人融资贷款信息
export function deleteMyFinance(financeId:string){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/finance/delete/${financeId}`,
      method:RequestMethod.DELETE,
      header:{
        Authorization:globalThis.token
      }
    })
}