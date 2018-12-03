function logMessage(message)
	try
		fprintf(['[' datestr(now) ']: ' char(message) '\n'])
	catch
		fprintf(['[' datestr(now) ']: (unintelligible log data format)\n'])
	end
end