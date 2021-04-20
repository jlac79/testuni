select distinct                
   pr.sNF                
   ,so.id as idRemessa                
   ,case when so.isActive = 1 then 'O' else 'S' end as orderOrShipment -- tbOrder or tbShipmentOrder                
   ,mp.idNumStatusSatelital                
   ,'Processo Atualização Status: ' + mp.statusDescriptionExterno as DescriptionStatus                
   ,dbo.fnToDate(sDataStatus + sHoraStatus, 3) as DateStatus                
   ,row_number() over(partition by pr.sNF,so.id                 
                order by dbo.fnToDate(sDataStatus + sHoraStatus, 3),st.Ordinal   desc) as cnt                
   ,mp.statusExterno as StatusLog                
   ,case mp.idNumStatusSatelital                 
    when 140 then GETDATE()                 
    when 101 then GETDATE()                
    when 133 then GETDATE()                
    else null end as ExpeditionDate                
 --into #TempPedidos                
 from 
 
 [dbo].tbShipmentOrder so with(nolock)   
	inner join [dbo].tbPreviaPedidosRetornoLogistica pr with(nolock)  
		on so.idCampaign = pr.idCampaign  and pr.sNomeArquivo = '10/04/2021T06-05-19_URBANO.VIRTUAL'               
	inner join [dbo].tbStatusMappingLogistica mp  WITH(NOLOCK)          
		on pr.sOcorrenciaTrasportadora = mp.StatusExterno and mp.Trasportadora = pr.sNomeLogistica  and 'URBANO' = mp.Trasportadora  
	inner join tbstatus st with(nolock)  on st.idNumStatus = mp.idNumStatusSatelital  
	cross apply dbo.fnUnformatOrderNumber(pr.[Pedido]) fn           
             
 where     
    fn.ReturnOrderID = so.idOrder and  fn.idCampaign = so.idCampaign and fn.idAction = so.action and  fn.sequential = so.sequential           
    and   pr.dProcessamento is null and   pr.idPendencia is null   





select pr.sNomeArquivo, *	 from 
 
 [dbo].tbShipmentOrder so with(nolock)   
	inner join [dbo].tbPreviaPedidosRetornoLogistica pr with(nolock)  
		on so.idCampaign = pr.idCampaign  and pr.sNomeArquivo = '10/04/2021T06-05-19_URBANO.VIRTUAL'   

		where so.idCampaign = 'BRBAR'