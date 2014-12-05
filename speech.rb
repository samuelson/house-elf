require 'pocketsphinx-ruby'

#Phrase to listen for
listening_keyword = "house elf"

command_list = {
	listening_keyword => "Listening",
  "living room light" => "pl a1 on",
  "Turn off living room light" => "pl a1 off",
  "bedroom light" => "pl a2 on",
  "Turn off bedroom light" => "pl a2 off",
  "Play music" => "PM",
  "Stop music" => "SM",
	"Forget it" => "Forgotten"
}

puts "Availible Commands:"
command_list.each do |key, value|
		puts key
end

configuration = Pocketsphinx::Configuration::Grammar.new do
	sentence listening_keyword
	command_list.each do |key, value|
		sentence key
	end
end

configuration['vad_threshold'] = 3

recognizer = Pocketsphinx::LiveSpeechRecognizer.new(configuration)


#By default don't listen for anything but
listening = false
recognizer.recognize do |speech|
	if listening then
		puts command_list[speech]
		puts speech

		#Stop listening after the command is done
		listening = false
	end

	#If you hear the word, start listening for the next round
	listening = true if speech == listening_keyword.downcase
	puts listening
end
