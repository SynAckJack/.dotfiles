
#Keeping a note of useful commands and explanations.
#I'm still very new to bash 🤷‍♂️


#Retrieve text "2018.3" from GPGTools home page.
# curl -s "website" will return the full <html> of the web page
# grep returns href="/releases/gpgsuite/2018.3/release-notes.html"
# awk -F will find every instance of the character "/" and assign it to an 'array'
# print $4 prints the fourth object of the array (target + 1)
curl -s "https://gpgtools.org" | grep "version" | awk -F "/" '{ print $4 }'