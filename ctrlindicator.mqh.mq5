#include "ctrlindicator.mqh"
#include "definitions.mqh"

CtrlIndicator::CtrlIndicator(){}

bool CtrlIndicator::start(void)
{
   _iRSI_handle=iRSI(Symbol(),Period(),14,PRICE_CLOSE);
   _iMA_handle1 =iMA(Symbol(),Period(),8,0,MODE_SMA,PRICE_CLOSE);
   _iMA_handle2 =iMA(Symbol(),Period(),21,0,MODE_SMA,PRICE_CLOSE);   
   
   ArraySetAsSeries(_iRSI_buf,true);
   ArraySetAsSeries(_iMA_buf1,true);
   ArraySetAsSeries(_iMA_buf2,true);
   
   if(_iRSI_handle==INVALID_HANDLE || _iMA_handle1 == INVALID_HANDLE || _iMA_handle2 == INVALID_HANDLE)
      return false;
   return true;
}

void CtrlIndicator::end(void)
{
//--- delete the indicator handle and deallocate the memory space it occupies
   IndicatorRelease(_iRSI_handle);
   IndicatorRelease(_iMA_handle1);
   IndicatorRelease(_iMA_handle2);
//--- free the iRSI_buf dynamic array of data
   ArrayFree(_iRSI_buf);
   ArrayFree(_iMA_buf1);
   ArrayFree(_iMA_buf2);
}

bool CtrlIndicator::update(void)
{
   _err_code = CopyBuffer(_iRSI_handle,0,1,COUNT_INPUTS,_iRSI_buf);                  if(_err_code<0) return false;
   _err_code = CopyBuffer(_iMA_handle1,0,1,COUNT_INPUTS,_iMA_buf1);                  if(_err_code<0) return false;
   _err_code = CopyBuffer(_iMA_handle2,0,1,COUNT_INPUTS,_iMA_buf2);                  if(_err_code<0) return false;
   _err_code = CopyRates(_Symbol,PERIOD_M1,1,COUNT_INPUTS,_rates);                   if(_err_code<0) return false;
   _err_code = CopyRealVolume(_Symbol,PERIOD_M1,1,COUNT_INPUTS,_real_volume);        if(_err_code<0) return false;
   return true;
}


double CtrlIndicator::getRSI(int index) const { return _iRSI_buf[index]; }
double CtrlIndicator::getMA1(int index) const { return _iMA_buf1[index]; }
double CtrlIndicator::getMA2(int index) const { return _iMA_buf2[index]; }
long CtrlIndicator::getVolume(int index) const { return _real_volume[index]; }   
MqlRates CtrlIndicator::getRates(int index) const { return _rates[index]; }      