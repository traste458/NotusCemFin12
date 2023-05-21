//////////////////// Agenda file for CalendarXP 9.0 /////////////////
// This file is totally configurable. You may remove all the comments in this file to minimize the download size.
/////////////////////////////////////////////////////////////////////

//////////////////// Define agenda events ///////////////////////////
// Usage -- fAddEvent(year, month, day, message, action, bgcolor, fgcolor, bgimg, boxit, html);
// Notice:
// 1. The (year,month,day) identifies the date of the agenda.
// 2. In the action part you can use any javascript statement, or use " " for doing nothing.
// 3. Assign "null" value to action will result in a line-through effect(can't be selected).
// 4. html is the HTML string to be shown inside the agenda cell, usually an <img> tag.
// 5. fgcolor is the font color for the specific date. Setting it to ""(empty string) will make the fonts invisible and the date unselectable.
// 6. bgimg is the url of the background image file for the specific date.
// 7. boxit is a boolean that enables the box effect using the bgcolor when set to true.
// ** REMEMBER to enable respective flags of the gAgendaMask option in the theme, or it won't work.
/////////////////////////////////////////////////////////////////////

// fAddEvent(2003,12,2," Click me to active your email client. ","popup('mailto:any@email.address.org?subject=email subject')","#87ceeb","dodgerblue",null,true);
// fAddEvent(2004,4,1," Let's google. ","popup('http://www.google.com','_top')","#87ceeb","dodgerblue",null,true);
// fAddEvent(2004,9,23, "Hello World!\nYou can't select me.", null, "#87ceeb", "dodgerblue");




///////////// Dynamic holiday calculations /////////////////////////
// This function provides you a flexible way to make holidays of your own. (It's optional.)
// Once defined, it'll be called every time the calendar engine renders the date cell;
// With the date passed in, just do whatever you want to validate whether it is a desirable holiday;
// Finally you should return an agenda array like [message, action, bgcolor, fgcolor, bgimg, boxit, html] 
// to tell the engine how to render it. (returning null value will make it rendered as default style)
// ** REMEMBER to enable respective flags of the gAgendaMask option in the theme, or it won't work.
////////////////////////////////////////////////////////////////////
function fHoliday(y,m,d) {
    var rE=fGetEvent(y,m,d), r=null;

    // you may have sophisticated holiday calculation set here, following are only simple examples.
    if (m==1&&d==1)
        r=[" Enero 1, "+y+" \n Feliz Año Nuevo! ",gsAction,"red","red"];
    else if (m==12&&d==25)
        r=[" Diciembre 25, "+y+" \n Feliz Navidad! ",gsAction,"red","red"];
    else if (m==12&&d==25)
        r=[" Diciembre 25, "+y+" \n Feliz Navidad! ",gsAction,"red","red"];
    else if (m==1&&d==9)
        r=[" Enero 9, "+y+" \n  ",gsAction,"red","red"];
    else if (m==3&&d==8)
        r=[" Marzo 8, "+y+" \n Día Internacional de la Mujer ",gsAction,"red","red"];
    else if (m==3&&d==20)
        r=[" Marzo 20, "+y+" \n  ",gsAction,"red","red"];
    else if (m==4&&d==13)
        r=[" Abril 13, "+y+" \n Jueves Santo ",gsAction,"red","red"];
    else if (m==4&&d==14)
        r=[" Abril 14, "+y+" \n Viernes Santo ",gsAction,"red","red"];
    else if (m==5&&d==1)
        r=[" Mayo 1, "+y+" \n Día Internacional del Trabajo ",gsAction,"red","red"];
    else if (m==5&&d==29)
        r=[" Mayo 29, "+y+" \n ",gsAction,"red","red"];
    else if (m==6&&d==19)
        r=[" Junio 19, "+y+" \n ",gsAction,"red","red"];
    else if (m==6&&d==26)
        r=[" Junio 26, "+y+" \n ",gsAction,"red","red"];
    else if (m==7&&d==3)
        r=[" Julio  3, "+y+" \n  ",gsAction,"red","red"];
    else if (m==7&&d==20)
        r=[" Julio 20, "+y+" \n Día de la Independencia ",gsAction,"red","red"];
    else if (m==8&&d==7)
        r=[" Agosto 7, "+y+" \n Batalla de Boyaca ",gsAction,"red","red"];
    else if (m==8&&d==21)
        r=[" Agosto 21, "+y+" \n  ",gsAction,"red","red"];
    else if (m==10&&d==16)
        r=[" Octubre 16, "+y+" \n Día de la Raza ",gsAction,"red","red"];
    else if (m==6&&d==11)
        r=[" Noviembre 6, "+y+" \n Día de los Santos ",gsAction,"red","red"];
    else if (m==11&&d==13)
        r=[" Noviembre 13, "+y+" \n ",gsAction,"red","red"];
    else if (m==12&&d==8)
        r=[" Diciembre 8, "+y+" \n Día de las Velitas",gsAction,"red","red"];

    return rE?rE:r; // favor events over holidays
}


