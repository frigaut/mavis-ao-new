pro registrations
file = "MAVIS Science Workshop December 2019 - Registration.csv"
readcol,file,firstname,surname,aff,F='x,x,x,x,a,a,a',skipline=1
nline = n_elements(aff)
firstname = strarr(nline)
surname = strarr(nline)
aff = strarr(nline)
line=""
openr,lun,file,/get_lun
readf,lun,line
for i = 0, nline-1 do begin
   readf,lun,line
   lines = STRSPLIT(line,',',/extr)
   name = STRSPLIT(lines[1]," ",/ex)
   s=size(name)
   if s[1] eq 2 then begin
      firstname[i] = STRSPLIT((STRSPLIT(lines[1]," ",/ex))[0],'"',/ex)
      surname[i] = STRSPLIT((STRSPLIT(lines[1]," ",/ex))[1],'"',/ex)
   endif else begin
      firstname[i] = STRSPLIT(name[0],'"',/ex)
      surname[i] = STRSPLIT(STRJOIN(name[1:*]," ",/single),'"',/ex)
   endelse      
   aff[i] = STRSPLIT(lines[3],'"',/ex)
endfor
free_lun,lun

openw,lun,"tmp.html",/get_lun
printf,lun,FORMAT='(%"Currently, we have %d registered participants, not counting the <a href=\"#remoteparticipants\">remote participants</a>.</p>\n")',nline
printf,lun,'<table class="table table-striped table-bordered u-Margin0">'
printf,lun," <thead>"
printf,lun,"<tr>"
printf,lun,"<th>Full Name</th>"
printf,lun,"<th>Affiliation</th>"
printf,lun,"</tr>"
printf,lun,"</thead>"
printf,lun,"<tbody>"

for i = 0,nline-1 do printf,lun,format='(%"<tr><td>%s %s</td><td>%s</td></tr>")',firstname[i],surname[i],aff[i]
;
free_lun, lun

spawn,"cat participants_head.html tmp.html participants_foot.html > ../participants.html"
file_delete,"tmp.html"                                                                         ;
print,format='(%"Updated ../participants.html from %s")',file
end
