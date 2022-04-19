%dw 2.0
output application/xml skipNullOn = 'everywhere'
import * from dw::core::Strings

var DftIFD 		= vars.PART_INB_CrossRefValues
var SkuVal		= payload
var Warehouse	= vars.PART_INB_CrossRefValues.WHSE_ID[0][0]
// var Warehouse   = '----'
var client		= DftIFD."HOSTMAP"."CLIENTID"[0] default ''
var UpcDta		= payload distinctBy $.IUPC
var WhVal 		= '----'
fun PrefixZero(atr) = ('000' ++ atr)[sizeOf(atr) to (sizeOf(atr) + 2)]

---
{
	PART_INB_IFD: {
//	(payload map (SkuVal,idx) ->
			CTRL_SEG: {
				TRNNAM: DftIFD."CTRL_SEG"."TRANNAM"[0],
				TRNVER: DftIFD."CTRL_SEG"."TRANVER"[0],
//				WHSE_ID: Warehouse,
				WHSE_ID: WhVal,
						
			PART_SEG: {
				SEGNAM: DftIFD."PART_SEG"."SEGNAM"[0],
				TRNTYP: if (SkuVal.PCGCDE[0] == 'A' or SkuVal.PCGCDE[0] == 'U') 'R' else SkuVal.PCGCDE[0],
				PRTNUM: SkuVal.IVNDPN[0] as String,
				PRT_CLIENT_ID: client, 
//PEGD -669		COMCOD: DftIFD."PART_SEG"."COMCOD"[0],
				COMCOD: if (SkuVal.CTYORG[0] !='') SkuVal.CTYORG[0] else DftIFD."PART_SEG"."COMCOD"[0],
				SUBCFG: DftIFD."PART_SEG"."SUBCFG"[0],
				SCFPOS: DftIFD."PART_SEG"."SCFPOS"[0],
				DTLCFG: DftIFD."PART_SEG"."DTLCFG"[0],
				DCFPOS: DftIFD."PART_SEG"."DCFPOS"[0],
//				TYPCOD: DftIFD."PART_SEG"."TYPCOD"[0],
				TYPCOD: (SkuVal filter $.ITANAM == 'SPINE')[0].ITAVAL,
//				PRTFAM: (PrefixZero(SkuVal.IDEPT[0] as String)  ++ PrefixZero(SkuVal.ISDEPT[0] as String)),
				PRTFAM: if (trim(SkuVal.ZONE[0]) == 'RP') 'PB1' else 
							if (trim(SkuVal.ZONE[0]) == 'FICT') 'PB2' else
								if (trim(SkuVal.ZONE[0]) == 'NFICT') 'PB3' else
									if (trim(SkuVal.ZONE[0]) == 'CHILD') 'PB4' else
//										if (trim(SkuVal.ZONE[0]) == 'PEREN') 'PEREN' else 'PEREN' default 'PEREN',
										if (trim(SkuVal.ZONE[0]) == 'PEREN') 'PEREN' else ' ' default ' ',
				LODLVL: DftIFD."PART_SEG"."LODLVL"[0],
				ORGFLG: DftIFD."PART_SEG"."ORGFLG"[0],
				REVFLG: DftIFD."PART_SEG"."REVFLG"[0],
				LOTFLG: DftIFD."PART_SEG"."LOTFLG"[0],
				SUP_LOT_FLG: DftIFD."PART_SEG"."SUP_LOT_FLG"[0],
// 				UNTCST: DftIFD."PART_SEG"."UNTCST"[0],
//				UNTCST: SkuVal.PLNAMT[0],
//				UNTCST: trim(substringAfter(SkuVal.PCGDTA[0], "P")) as Number default 0,
				UNTCST: trim(substringAfter((substringBefore(SkuVal.PCGDTA[0], "P")), "C")) as Number default 0,
				REOQTY: DftIFD."PART_SEG"."REOQTY"[0],
				REOPNT: DftIFD."PART_SEG"."REOPNT"[0],
				PKGTYP: DftIFD."PART_SEG"."PKGTYP"[0],
				
			/*	STKUOM: if (SkuVal.ISTDPK[0] == 1)
						(if(SkuVal.ISET[0] == '7' or SkuVal.ISET[0] == '8') "PP"
							else "PC"
						) else (if (SkuVal.IMINPK[0] == 1) "PC"
							else "IP"
							), */
				STKUOM : 'EA', /* pending */
				UNTPAK: DftIFD."PART_SEG"."UNTPAK"[0],
				PAKUOM: DftIFD."PART_SEG"."PAKUOM"[0],
				UNTCAS: DftIFD."PART_SEG"."UNTCAS"[0],
				CASUOM: DftIFD."PART_SEG"."CASUOM"[0],
				UNTPAL: DftIFD."PART_SEG"."UNTPAL"[0],
				PALUOM: DftIFD."PART_SEG"."PALUOM"[0],
				UNTLEN: DftIFD."PART_SEG"."UNTLEN"[0],
				PAKLEN: DftIFD."PART_SEG"."PAKLEN"[0],
				GRSWGT: DftIFD."PART_SEG"."GRSWGT"[0],
				NETWGT: DftIFD."PART_SEG"."NETWGT"[0],
//				FTPCOD: DftIFD."PART_SEG"."FTPCOD"[0],
				FTPCOD: SkuVal.DSC151[0],
				ABCCOD: DftIFD."PART_SEG"."ABCCOD"[0],
				FIFWIN: DftIFD."PART_SEG"."FIFWIN"[0],
//				VELZON: DftIFD."PART_SEG"."VELZON"[0],
				VELZON: if (SkuVal.IVLRK1[0] != '') SkuVal.IVLRK1[0] else 'B',
				RCVSTS: DftIFD."PART_SEG"."RCVSTS"[0],
				RCVUOM: DftIFD."PART_SEG"."RCVUOM"[0],
//				RCVFLG: DftIFD."PART_SEG"."RCVFLG"[0],
				RCVFLG: if (SkuVal.PCGCDE[0] == 'A') DftIFD."PART_SEG"."RCVFLG"[0] else null,
				PRDFLG: DftIFD."PART_SEG"."PRDFLG"[0],
				LTLCLS: DftIFD."PART_SEG"."LTLCLS"[0],
				WIP_PRTFLG: DftIFD."PART_SEG"."WIP_PRTFLG"[0],
				DTE_CODE: DftIFD."PART_SEG"."DTE_CODE"[0],
				AGE_PFLNAM: DftIFD."PART_SEG"."AGE_PFLNAM"[0],
				CATCH_COD: DftIFD."PART_SEG"."CATCH_COD"[0],
				CATCH_UNTTYP: DftIFD."PART_SEG"."CATCH_UNTTYP"[0],
				CATCH_UNTWGT: DftIFD."PART_SEG"."CATCH_UNTWGT"[0],
//				CATCH_UNTCST: DftIFD."PART_SEG"."CATCH_UNTCST"[0],
// as part of the change "PEGD-162"
				CATCH_UNTCST: trim(substringAfter(SkuVal.PCGDTA[0], "P")) as Number default 0,
				MIN_CATCH_QTY: DftIFD."PART_SEG"."MIN_CATCH_QTY"[0],
				MAX_CATCH_QTY: DftIFD."PART_SEG"."MAX_CATCH_QTY"[0],
				CNZFLG: DftIFD."PART_SEG"."CNZFLG"[0],
				CNZAMT: DftIFD."PART_SEG"."CNZAMT"[0],
				TIMCOD: DftIFD."PART_SEG"."TIMCOD"[0],
				STCCOD: DftIFD."PART_SEG"."STCCOD"[0],
				PARCEL_FLG: DftIFD."PART_SEG"."PARCEL_FLG"[0],
				HAZMAT_FLG: DftIFD."PART_SEG"."HAZMAT_FLG"[0],
				NSTCLS: DftIFD."PART_SEG"."NSTCLS"[0],
				INSFLG: DftIFD."PART_SEG"."INSFLG"[0],
				SER_TYP: DftIFD."PART_SEG"."SER_TYP"[0],
				SER_LVL: DftIFD."PART_SEG"."SER_LVL"[0],
				WGTCOD: DftIFD."PART_SEG"."WGTCOD"[0],
				LOD_TAG_ENCODE: DftIFD."PART_SEG"."LOD_TAG_ENCODE"[0],
				SUB_TAG_ENCODE: DftIFD."PART_SEG"."SUB_TAG_ENCODE"[0],
				CO_PREFIX_LEN: DftIFD."PART_SEG"."CO_PREFIX_LEN"[0],
				TIME_TO_WARN_FOR_EXP: DftIFD."PART_SEG"."TIME_TO_WARN_FOR_EXP"[0],
				PRTADJFLG: DftIFD."PART_SEG"."PRTADJFLG"[0],
				CNTBCK_ENA_FLG: DftIFD."PART_SEG"."CNTBCK_ENA_FLG"[0],
				CNT_THR_CST: DftIFD."PART_SEG"."CNT_THR_CST"[0],
				CNT_THR_UNIT: DftIFD."PART_SEG"."CNT_THR_UNIT"[0],
//				PRTSTYLE: DftIFD."PART_SEG"."PRTSTYLE"[0],
				PRTSTYLE: (SkuVal filter ($.ITANAM == 'MAPS' or $.ITANAM == 'SPIRAL'))[0].ITAVAL,
				PRTFIT: DftIFD."PART_SEG"."PRTFIT"[0],
//				PRTCOLOR: DftIFD."PART_SEG"."PRTCOLOR"[0],
				PRTCOLOR: (SkuVal filter $.ITANAM == 'VALUE')[0].ITAVAL,
//				PRTSIZE: DftIFD."PART_SEG"."PRTSIZE"[0],
				PRTSIZE: (SkuVal filter $.ITANAM == 'SIZE')[0].ITAVAL,
				PCK_STEAL_FLG: DftIFD."PART_SEG"."PCK_STEAL_FLG"[0],
				CATCH_UNTWGT_MU: DftIFD."PART_SEG"."CATCH_UNTWGT_MU"[0],
				GRSWGT_MU: DftIFD."PART_SEG"."GRSWGT_MU"[0],
				NETWGT_MU: DftIFD."PART_SEG"."NETWGT_MU"[0],
				PAKLEN_MU: DftIFD."PART_SEG"."PAKLEN_MU"[0],
				UNTLEN_MU: DftIFD."PART_SEG"."UNTLEN_MU"[0],
				CRNCY_CODE: DftIFD."PART_SEG"."CRNCY_CODE"[0],
				BOX_PCK_FLG: DftIFD."PART_SEG"."BOX_PCK_FLG"[0],
				AVG_CATCH: DftIFD."PART_SEG"."AVG_CATCH"[0],
				BTO_SUBST_PRTNUM: DftIFD."PART_SEG"."BTO_SUBST_PRTNUM"[0],
				BTO_OBSO_FLG: DftIFD."PART_SEG"."BTO_OBSO_FLG"[0],
				DSPUOM: DftIFD."PART_SEG"."DSPUOM"[0],
				RPTUOM: DftIFD."PART_SEG"."RPTUOM"[0],
				IGNORE_CON_FLG: DftIFD."PART_SEG"."IGNORE_CON_FLG"[0],
				LOT_FMT_ID: DftIFD."PART_SEG"."LOT_FMT_ID"[0],
				ABS_ORDINV_WIN: DftIFD."PART_SEG"."ABS_ORDINV_WIN"[0],
				ABS_ORDINV_CODE: DftIFD."PART_SEG"."ABS_ORDINV_CODE"[0],
				THRESH_PCK_VAR: DftIFD."PART_SEG"."THRESH_PCK_VAR"[0],
				DTE_WIN_TYP: DftIFD."PART_SEG"."DTE_WIN_TYP"[0],
				CSTMS_ITM_TYP: DftIFD."PART_SEG"."CSTMS_ITM_TYP"[0],
				CSTMS_CRNCY: DftIFD."PART_SEG"."CSTMS_CRNCY"[0],
				DFLT_ORGCOD: DftIFD."PART_SEG"."DFLT_ORGCOD"[0],
				CSTMS_VAT_COD: DftIFD."PART_SEG"."CSTMS_VAT_COD"[0],
				DTY_STMP_TRK_FLG: DftIFD."PART_SEG"."DTY_STMP_TRK_FLG"[0],
				CSTMS_CST: DftIFD."PART_SEG"."CSTMS_CST"[0],
				CSTMS_CMMDTY_COD: DftIFD."PART_SEG"."CSTMS_CMMDTY_COD"[0],
				VELZON_RECALC_FLG: DftIFD."PART_SEG"."VELZON_RECALC_FLG"[0],
				PRT_DISPTN: DftIFD."PART_SEG"."PRT_DISPTN"[0],
				DEPT_COD: DftIFD."PART_SEG"."DEPT_COD"[0], 
				UNT_INS_VAL: DftIFD."PART_SEG"."UNT_INS_VAL"[0],
				REL_VAL: DftIFD."PART_SEG"."REL_VAL"[0],
				REL_VAL_UNT_TYP: DftIFD."PART_SEG"."REL_VAL_UNT_TYP"[0],
				PRT_DISP: DftIFD."PART_SEG"."PRT_DISP"[0],
				HTSNUM: DftIFD."PART_SEG"."HTSNUM"[0],
				SCHEDBNUM: DftIFD."PART_SEG"."SCHEDBNUM"[0],
				PRC_FOR_RPS_FLG: DftIFD."PART_SEG"."PRC_FOR_RPS_FLG"[0],
				ATTR_STR1: DftIFD."PART_SEG"."ATTR_STR1"[0],
				ATTR_STR2: DftIFD."PART_SEG"."ATTR_STR2"[0],
				ATTR_STR3: DftIFD."PART_SEG"."ATTR_STR3"[0],
				ATTR_STR4: DftIFD."PART_SEG"."ATTR_STR4"[0],
				ATTR_STR5: DftIFD."PART_SEG"."ATTR_STR5"[0],
				ATTR_STR6: DftIFD."PART_SEG"."ATTR_STR6"[0],
				ATTR_STR7: DftIFD."PART_SEG"."ATTR_STR7"[0],
				ATTR_STR8: DftIFD."PART_SEG"."ATTR_STR8"[0],
				ATTR_STR9: DftIFD."PART_SEG"."ATTR_STR9"[0],
				ATTR_STR10: DftIFD."PART_SEG"."ATTR_STR10"[0],
				ATTR_INT1: PrefixZero(SkuVal.IDEPT[0] as String),
			 	ATTR_INT2: PrefixZero(SkuVal.ISDEPT[0] as String),
	 			ATTR_INT3: PrefixZero(SkuVal.ICLAS[0] as String),
	 			ATTR_INT4: PrefixZero(SkuVal.ISCLAS[0] as String),
				ATTR_INT5: DftIFD."PART_SEG"."ATTR_INT5"[0],
				ATTR_FLT1: DftIFD."PART_SEG"."ATTR_FLT1"[0],
				ATTR_FLT2: DftIFD."PART_SEG"."ATTR_FLT2"[0],
				ATTR_FLT3: DftIFD."PART_SEG"."ATTR_FLT3"[0],
				ATTR_DTE1: DftIFD."PART_SEG"."ATTR_DTE1"[0],
				ATTR_DTE2: DftIFD."PART_SEG"."ATTR_DTE2"[0],
//				DSP_PRTNUM: if (trim(SkuVal.IMFGNO[0]) != '') SkuVal.IMFGNO[0] else SkuVal.INUMBR[0] as String ,
				ATTR_STR11: DftIFD."PART_SEG"."ATTR_STR11"[0],
				ATTR_STR12: DftIFD."PART_SEG"."ATTR_STR12"[0],
				ATTR_STR13: DftIFD."PART_SEG"."ATTR_STR13"[0],
				ATTR_STR14: DftIFD."PART_SEG"."ATTR_STR14"[0],
				ATTR_STR15: DftIFD."PART_SEG"."ATTR_STR15"[0], 
				ATTR_STR16: DftIFD."PART_SEG"."ATTR_STR16"[0],
				ATTR_STR17: DftIFD."PART_SEG"."ATTR_STR17"[0],
				ATTR_STR18: DftIFD."PART_SEG"."ATTR_STR18"[0],
				PAKFLG: DftIFD."PART_SEG"."PAKFLG"[0],
// During SIT, WMS team asked not to send "PRTHTCY", hence commenting out
//				PRTHRCY: SkuVal.IATRB3[0],

				
			PART_DESCRIPTION_SEG: {
				SEGNAM: DftIFD."PART_DESCRIPTION_SEG"."SEGNAM"[0],
				LNGDSC: SkuVal.IDESCR[0],
//				SHORT_DSC: DftIFD."PART_DESCRIPTION_SEG"."SHORT_DSC"[0],
				SHORT_DSC: SkuVal.ISORT[0],
				LOCALE_ID: DftIFD."PART_DESCRIPTION_SEG"."LOCALE_ID"[0]
				},
		
		/* 	REPACK_CLASS_SEG: {
				SEGNAM:  DftIFD."REPACK_CLASS_SEG"."SEGNAM"[0],
				RPKCLS:  DftIFD."REPACK_CLASS_SEG"."RPKCLS"[0],
				SRTSEQ:  DftIFD."REPACK_CLASS_SEG"."SRTSEQ"[0]
				},*/
	
		(UpcDta map (UpcVal, UpcIdx) -> {
			PART_ALT_PRTNUM_SEG: if (UpcVal.IUPC != 0 and UpcVal.IUPC != null ) {
				SEGNAM:  DftIFD."PART_ALT_PRTNUM_SEG_UPC"."SEGNAM"[0],
				ALT_PRT_TYP:  DftIFD."PART_ALT_PRTNUM_SEG_UPC"."ALT_PRT_TYP"[0],
				ALT_PRTNUM:  UpcVal.IUPC default 0 as String,
				UOMCOD:  DftIFD."PART_ALT_PRTNUM_SEG_UPC"."UOMCOD"[0],
				RFID_FILTER_VAL_COD:  DftIFD."PART_ALT_PRTNUM_SEG_UPC"."RFID_FILTER_VAL_COD"[0],
				DSP_PRT_FLG:  DftIFD."PART_ALT_PRTNUM_SEG_UPC"."DSP_PRT_FLG"[0]
				} else null}),
	
			PART_ALT_PRTNUM_SEG: if (trim(SkuVal.IMFGNO[0]) != ''){
				SEGNAM:  DftIFD."PART_ALT_PRTNUM_SEG_VDR"."SEGNAM"[0],
				ALT_PRT_TYP:  DftIFD."PART_ALT_PRTNUM_SEG_VDR"."ALT_PRT_TYP"[0],
				ALT_PRTNUM:  SkuVal.IMFGNO[0] default ' ',
				UOMCOD:  DftIFD."PART_ALT_PRTNUM_SEG_VDR"."UOMCOD"[0],
				RFID_FILTER_VAL_COD:  DftIFD."PART_ALT_PRTNUM_SEG_VDR"."RFID_FILTER_VAL_COD"[0],
				DSP_PRT_FLG:  DftIFD."PART_ALT_PRTNUM_SEG_VDR"."DSP_PRT_FLG"[0]
				} else null,
	
			PART_FOOTPRINT_SEG: if(trim(SkuVal.IDLGTH[0]) as Number != 0 and trim(SkuVal.IDWDTH[0]) as Number != 0 and trim(SkuVal.IDHGHT[0]) as Number != 0 and trim(SkuVal.IWGHT[0]) as Number != 0){
				SEGNAM:  DftIFD."PART_FOOTPRINT_SEG"."SEGNAM"[0],
//				FTPCOD:  if(SkuVal.ISTDPK[0] > 1) ("CS" ++ SkuVal.ISTDPK[0] as String) else "PC",
//				LNGDSC:   if(SkuVal.ISTDPK[0] > 1) ("CS" ++ SkuVal.ISTDPK[0] as String) else "PC",
//				SHORT_DSC:  if(SkuVal.ISTDPK[0] > 1) ("CS" ++ SkuVal.ISTDPK[0] as String) else "PC",
				FTPCOD: SkuVal.DSC151[0],
				LNGDSC: DftIFD."PART_FOOTPRINT_SEG"."LNGDSC"[0],
				LOCALE_ID:  DftIFD."PART_FOOTPRINT_SEG"."LOCALE_ID"[0],
				CASLVL:  DftIFD."PART_FOOTPRINT_SEG"."CASLVL"[0],
				NSTLEN:  DftIFD."PART_FOOTPRINT_SEG"."NSTLEN"[0],
				NSTLEN_MU:  DftIFD."PART_FOOTPRINT_SEG"."NSTLEN_MU"[0],
				NSTWID:  DftIFD."PART_FOOTPRINT_SEG"."NSTWID"[0],
				NSTHGT:  DftIFD."PART_FOOTPRINT_SEG"."NSTHGT"[0],
				PAL_STCK_HGT:  DftIFD."PART_FOOTPRINT_SEG"."PAL_STCK_HGT"[0],
				DEF_ASSET_TYP:  DftIFD."PART_FOOTPRINT_SEG"."DEF_ASSET_TYP"[0],
				DEFFTP_FLG:  DftIFD."PART_FOOTPRINT_SEG"."DEFFTP_FLG"[0],
				LOAD_ATTR1_CFG:  DftIFD."PART_FOOTPRINT_SEG"."LOAD_ATTR1_CFG"[0],
				LOAD_ATTR2_CFG:  DftIFD."PART_FOOTPRINT_SEG"."LOAD_ATTR2_CFG"[0],
				LOAD_ATTR3_CFG:  DftIFD."PART_FOOTPRINT_SEG"."LOAD_ATTR3_CFG"[0],
				LOAD_ATTR4_CFG:  DftIFD."PART_FOOTPRINT_SEG"."LOAD_ATTR4_CFG"[0],
				LOAD_ATTR5_CFG:  DftIFD."PART_FOOTPRINT_SEG"."LOAD_ATTR5_CFG"[0],
				STKMTD:  DftIFD."PART_FOOTPRINT_SEG"."STKMTD"[0],
				
//			

// 			PART_FOOTPRINT_DTL_SEG: if (DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."CTRLFLAG"[0] == '1') {
 			PART_FOOTPRINT_DTL_SEG: if(trim(SkuVal.IDLGTH[0]) as Number != 0 and trim(SkuVal.IDWDTH[0]) as Number != 0 and trim(SkuVal.IDHGHT[0]) as Number != 0 and trim(SkuVal.IWGHT[0]) as Number != 0) {
				SEGNAM:  DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."SEGNAM"[0],
				UOMCOD:  DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."UOMCOD"[0],
				/*We have to send Running sequence number and due to this below given error conndition executed */
//				UOMLVL:  	if (DftIFD."PART_FOOTPRINT_DTL_SEG_PC"."CTRLFLAG"[0] == '1' and (DftIFD."PART_FOOTPRINT_DTL_SEG_IP"."CTRLFLAG"[0] == '1' and SkuVal.IMINPK[0] > 1 and SkuVal.IMINPK[0] < SkuVal.ISTDPK[0])) 2 
//							else 
//								if (DftIFD."PART_FOOTPRINT_DTL_SEG_PC"."CTRLFLAG"[0] == '1' or (DftIFD."PART_FOOTPRINT_DTL_SEG_IP"."CTRLFLAG"[0] == '1' and SkuVal.IMINPK[0] > 1 and SkuVal.IMINPK[0] < SkuVal.ISTDPK[0])) 1 
//								else 0,
//				LEN: if (SkuVal.IDLGTH[0] != 0) SkuVal.IDLGTH[0] else DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."LEN"[0],
//				WID: if (SkuVal.IDWDTH[0] != 0 and SkuVal.IMINPK[0] != 0) SkuVal.IDWDTH[0] * SkuVal.ISTDPK[0] else DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."WID"[0] ,
//				HGT: if (SkuVal.IDHGHT[0] != 0) SkuVal.IDHGHT[0] else DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."HGT"[0],
				UOMLVL:  DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."UOMLVL"[0],
 				LEN:  if (trim(SkuVal.IDLGTH[0]) as Number != 0) trim(SkuVal.IDLGTH[0]) as Number else DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."LEN"[0],
 				WID:  if (trim(SkuVal.IDWDTH[0]) as Number != 0) trim(SkuVal.IDWDTH[0]) as Number else DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."WID"[0],
 				HGT:  if (trim(SkuVal.IDHGHT[0]) as Number != 0) trim(SkuVal.IDHGHT[0]) as Number else DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."HGT"[0],
//				GRSWGT:  DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."GRSWGT"[0],
//				NETWGT:  DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."NETWGT"[0],

				GRSWGT:  trim(SkuVal.IWGHT[0]) as Number,
				NETWGT:  trim(SkuVal.IWGHT[0]) as Number,
				
				PAL_FLG:  DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."PAL_FLG"[0],
				CAS_FLG:  DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."CAS_FLG"[0],
				PAK_FLG:  DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."PAK_FLG"[0],
				STK_FLG:  DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."STK_FLG"[0],
				RCV_FLG:  DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."RCV_FLG"[0],
//				UNTQTY:  if (SkuVal.ISTDPK[0] != 0) SkuVal.ISTDPK[0] else DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."UNTQTY"[0],
				UNTQTY:  DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."UNTQTY"[0],
				LEN_MU:  DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."LEN_MU"[0],
				WID_MU:  DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."WID_MU"[0],
				HGT_MU:  DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."HGT_MU"[0],
				GRSWGT_MU:  DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."GRSWGT_MU"[0],
				NETWGT_MU:  DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."NETWGT_MU"[0],
				CTN_FLG:  DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."CTN_FLG"[0],
				THRESH_PCT:  DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."THRESH_PCT"[0],
				CTN_DSTR_FLG:  DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."CTN_DSTR_FLG"[0],
				BULK_PCK_FLG:  DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."BULK_PCK_FLG"[0]
				} else null,
 			
//			PART_FOOTPRINT_DTL_SEG: if (DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."CTRLFLAG"[0] == '1') {
			PART_FOOTPRINT_DTL_SEG: if(trim(SkuVal.IDLGTH[0]) as Number != 0 and trim(SkuVal.IDWDTH[0]) as Number != 0 and trim(SkuVal.IDHGHT[0]) as Number != 0 and trim(SkuVal.IWGHT[0]) as Number != 0) {
				SEGNAM:  DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."SEGNAM"[0],
				UOMCOD:  DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."UOMCOD"[0],
				
				/*UOM should be running sequence number and to arrive the correct running sequeunce below given if condition used */
//				UOMLVL:  if (DftIFD."PART_FOOTPRINT_DTL_SEG_PC"."CTRLFLAG"[0] == '1' and (DftIFD."PART_FOOTPRINT_DTL_SEG_IP"."CTRLFLAG"[0] == '1' and SkuVal.IMINPK[0] > 1 and SkuVal.IMINPK[0] < SkuVal.ISTDPK[0]) and
//							 DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."CTRLFLAG"[0] == '1') 
//							 3
//						 else 	if ((DftIFD."PART_FOOTPRINT_DTL_SEG_PC"."CTRLFLAG"[0] == '1' and (DftIFD."PART_FOOTPRINT_DTL_SEG_IP"."CTRLFLAG"[0] == '1' and SkuVal.IMINPK[0] > 1 and SkuVal.IMINPK[0] < SkuVal.ISTDPK[0])) or 
//						 			(DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."CTRLFLAG"[0] == '1' and (DftIFD."PART_FOOTPRINT_DTL_SEG_IP"."CTRLFLAG"[0] == '1' and SkuVal.IMINPK[0] > 1 and SkuVal.IMINPK[0] < SkuVal.ISTDPK[0])) or   	
//						 			(DftIFD."PART_FOOTPRINT_DTL_SEG_PC"."CTRLFLAG"[0] == '1' and  DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."CTRLFLAG"[0] == '1')) 
//						 				2
//						 		else
//						 			if (DftIFD."PART_FOOTPRINT_DTL_SEG_PC"."CTRLFLAG"[0] == '1' or (DftIFD."PART_FOOTPRINT_DTL_SEG_IP"."CTRLFLAG"[0] == '1' and SkuVal.IMINPK[0] > 1 and SkuVal.IMINPK[0] < SkuVal.ISTDPK[0]) or
//						 				DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."CTRLFLAG"[0] == '1')
//						 				1
//						 			else 
//						 				0,
//				LEN:  if (SkuVal.IDLGTH[0] != 0)  SkuVal.IDLGTH[0] else DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."LEN"[0],
//				WID:  if (SkuVal.IDWDTH[0] != 0 and SkuVal.IMINPK[0] != 0) SkuVal.IDWDTH[0] * SkuVal.ISTDPK[0] else DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."LEN"[0], 	/* need pallet qty */
//				HGT:  if (SkuVal.IDHGHT[0] != 0) SkuVal.IDHGHT[0] else DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."HGT"[0],
				UOMLVL:  DftIFD."PART_FOOTPRINT_DTL_SEG_CS"."UOMLVL"[0],
 				LEN:  if (trim(SkuVal.IDLGTH[0]) as Number != 0) trim(SkuVal.IDLGTH[0]) as Number else DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."LEN"[0],
 				WID:  if (trim(SkuVal.IDWDTH[0]) as Number != 0) trim(SkuVal.IDWDTH[0]) as Number else DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."WID"[0],
 				HGT:  if (trim(SkuVal.IDHGHT[0]) as Number != 0) trim(SkuVal.IDHGHT[0]) as Number else DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."HGT"[0],
//				GRSWGT:  DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."GRSWGT"[0],
//				NETWGT:  DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."NETWGT"[0],

				GRSWGT:  (trim(SkuVal.IWGHT[0]) as Number * 999999),
				NETWGT:  (trim(SkuVal.IWGHT[0]) as Number * 999999),

				PAL_FLG:  DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."PAL_FLG"[0],
				CAS_FLG:  DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."CAS_FLG"[0],
				PAK_FLG:  DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."PAK_FLG"[0],
				STK_FLG:  DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."STK_FLG"[0],
				RCV_FLG:  DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."RCV_FLG"[0],
				UNTQTY:  DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."UNTQTY"[0],
				LEN_MU:  DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."LEN_MU"[0],
				WID_MU:  DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."WID_MU"[0],
				HGT_MU:  DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."HGT_MU"[0],
				GRSWGT_MU:  DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."GRSWGT_MU"[0],
				NETWGT_MU:  DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."NETWGT_MU"[0],
				CTN_FLG:  DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."CTN_FLG"[0],
				THRESH_PCT:  DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."THRESH_PCT"[0],
				CTN_DSTR_FLG:  DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."CTN_DSTR_FLG"[0],
				BULK_PCK_FLG:  DftIFD."PART_FOOTPRINT_DTL_SEG_PA"."BULK_PCK_FLG"[0]
				} else null 
						
			} else null
		} /* end of SkuDta map *

				}/*end of CTRL_SEG */
				
			}
//			) /* end of SkuDta map */
					
		} /*end of PART_INB_IFD */ 
			
	} 