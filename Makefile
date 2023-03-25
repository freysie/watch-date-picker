qa:
#	xcodebuild test-without-building \
#		-disable-concurrent-destination-testing \
#		-project 'Examples/WatchDatePickerExamples.xcodeproj' \
#		-scheme 'Examples WatchKit App' \
#		-destination 'platform=watchOS Simulator,OS=8.0,name=Apple Watch Series 6 (40mm)' \
#		-destination 'platform=watchOS Simulator,OS=8.0,name=Apple Watch Series 6 (44mm)' \
#		-destination 'platform=watchOS Simulator,OS=8.0,name=Apple Watch Series 7 (41mm)' \
#		-destination 'platform=watchOS Simulator,OS=8.0,name=Apple Watch Series 7 (45mm)'
#
#	xcodebuild test-without-building \
#		-disable-concurrent-destination-testing \
#		-project 'Examples/WatchDatePickerExamples.xcodeproj' \
#		-scheme 'Examples WatchKit App' \
#		-destination 'platform=watchOS Simulator,OS=9.1,name=Apple Watch Series 6 (40mm)' \
#		-destination 'platform=watchOS Simulator,OS=9.1,name=Apple Watch Series 6 (44mm)' \
#		-destination 'platform=watchOS Simulator,OS=9.1,name=Apple Watch Series 8 (41mm)' \
#		-destination 'platform=watchOS Simulator,OS=9.1,name=Apple Watch Series 8 (45mm)' \
#		-destination 'platform=watchOS Simulator,OS=9.1,name=Apple Watch Ultra (49mm)'

	xcodebuild test \
		-disable-concurrent-destination-testing \
		-project 'Examples/WatchDatePickerExamples.xcodeproj' \
		-scheme 'Examples WatchKit App' \
		-destination 'platform=watchOS Simulator,OS=9.4,name=Apple Watch Series 6 (40mm)' \
		-destination 'platform=watchOS Simulator,OS=9.4,name=Apple Watch Series 8 (41mm)' \
		-destination 'platform=watchOS Simulator,OS=9.4,name=Apple Watch Series 6 (44mm)' \
		-destination 'platform=watchOS Simulator,OS=9.4,name=Apple Watch Series 8 (45mm)' \
		-destination 'platform=watchOS Simulator,OS=9.4,name=Apple Watch Ultra (49mm)'

install:
	export WDP_QA_PATH='../watch-date-picker-qa/9.4'
	export WDP_DOC_PATH='Sources/WatchDatePicker/Documentation.docc/Resources'

	cp "$WDP_QA_PATH/DatePicker-1@45mm~en.png" "$WDP_DOC_PATH/DatePicker-1.png"
	cp "$WDP_QA_PATH/DatePicker-2@45mm~en.png" "$WDP_DOC_PATH/DatePicker-2.png"
	cp "$WDP_QA_PATH/DatePicker-3@45mm~en.png" "$WDP_DOC_PATH/DatePicker-3.png"

	cp "$WDP_QA_PATH/DatePicker_date-1@45mm~en.png" "$WDP_DOC_PATH/DatePicker_date-1.png"
	cp "$WDP_QA_PATH/DatePicker_date-2@45mm~en.png" "$WDP_DOC_PATH/DatePicker_date-2.png"
	cp "$WDP_QA_PATH/DatePicker_hourAndMinute-1@45mm~en.png" "$WDP_DOC_PATH/DatePicker_hourAndMinute-1.png"
	cp "$WDP_QA_PATH/DatePicker_hourAndMinute-2@45mm~en.png" "$WDP_DOC_PATH/DatePicker_hourAndMinute-2.png"
	cp "$WDP_QA_PATH/StandaloneDateInputView@45mm~en.png" "$WDP_DOC_PATH/DateInputView.png"
	cp "$WDP_QA_PATH/StandaloneDateInputView@45mm~fr.png" "$WDP_DOC_PATH/DateInputView_fr.png"
	cp "$WDP_QA_PATH/StandaloneTimeInputView@45mm~en.png" "$WDP_DOC_PATH/TimeInputView.png"
	cp "$WDP_QA_PATH/StandaloneTimeInputView_24hr@45mm~en.png" "$WDP_DOC_PATH/TimeInputView_24hr.png"
	cp "$WDP_QA_PATH/StandaloneTimeInputView_24hrHidden@45mm~en.png" "$WDP_DOC_PATH/TimeInputView_24hrHidden.png"

#qa:
#	xcodebuild test-without-building \
#		-sdk watchsimulator9.4 \
#		-enableCodeCoverage NO \
#		-parallel-testing-enabled NO \
#		-disable-concurrent-destination-testing \
#		-maximum-concurrent-test-simulator-destinations 5 \
#		-project 'Examples/WatchDatePickerExamples.xcodeproj' \
#		-scheme 'Examples WatchKit App' \
#		-destination 'platform=watchOS Simulator,OS=9.4,name=Apple Watch Series 8 (41mm)' \
#		-destination 'platform=watchOS Simulator,OS=9.4,name=Apple Watch Series 8 (45mm)'

#		-destination 'platform=watchOS Simulator,OS=9.4,name=Apple Watch Series 6 (40mm)' \
#	  -destination 'platform=watchOS Simulator,OS=9.4,name=Apple Watch Series 6 (44mm)' \

#	  -maximum-concurrent-test-simulator-destinations 1

#	set -o pipefail &&

#		 \
#		| xcbeautify

#	xcodebuild test -scheme 'Examples WatchKit App' -destination 'platform=watchOS Simulator,OS=9.1,name=Apple Watch Series 6 (40mm)'
#	xcodebuild test -scheme 'Examples WatchKit App' -destination 'platform=watchOS Simulator,OS=9.1,name=Apple Watch Series 6 (44mm)'
#	xcodebuild test -scheme 'Examples WatchKit App' -destination 'platform=watchOS Simulator,OS=9.1,name=Apple Watch Series 8 (41mm)'
#	xcodebuild test -scheme 'Examples WatchKit App' -destination 'platform=watchOS Simulator,OS=9.1,name=Apple Watch Series 8 (45mm)'
#	xcodebuild test -scheme 'Examples WatchKit App' -destination 'platform=watchOS Simulator,OS=9.1,name=Apple Watch Ultra (49mm)'
