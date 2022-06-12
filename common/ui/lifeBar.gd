extends Control

func init(currentValue_,maxValue_):
	$ProgressBar.value=currentValue_
	$ProgressBar.max_value=maxValue_
	$Label.text=str(currentValue_)
	
func updateValue(value_):
	$ProgressBar.value=value_
	$Label.text=str(value_)
