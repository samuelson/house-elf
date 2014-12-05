require 'pocketsphinx-ruby'
require 'socket'

#Phrase to listen for
listening_keyword = "house elf"

command_list = {
	listening_keyword => "Listening",
  "living room light" => "pl a1 on",
  "turn off living room light" => "pl a1 off",
  "bedroom light" => "pl a2 on",
  "turn off bedroom light" => "pl a2 off",
  "play music" => "PM",
  "stop music" => "SM",
	"forget it" => "Forgotten"
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

s=TCPSocket.open("10.0.0.42",1099)

#By default don't listen for anything but
listening = false
recognizer.recognize do |speech|
	if listening then

		s.puts command_list[speech]				

		#Stop listening after the command is done
		listening = false
	end

	#If you hear the word, start listening for the next round
	listening = true if speech == listening_keyword.downcase
	puts listening
end
