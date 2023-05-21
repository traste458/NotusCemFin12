/* - - - - - - - - - - - - - - - - - - - - - - -
 JavaScript
 viernes, 20 de mayo de 2005 12:21:35
 HAPedit 3.1.11.111
 - - - - - - - - - - - - - - - - - - - - - - - */
// accumulate values to put into text area
var accumulated_output_info;

// add a labeled value to the text area
function accumulate_output( str )
{
   accumulated_output_info = accumulated_output_info + str + "\n";
}

// convert a 32-bit value to a 8-char hex string
function cvt_hex( val )
{
   var str="";
   var i;
   var v;

   for( i=7; i>=0; i-- )
   {
      v = (val>>>(i*4))&0x0f;
      str += v.toString(16);
   }
   return str;
}

// add a bit string to the output, inserting spaces as designated
function accumulate_val( label, val )
{
   accumulated_output_info += label + cvt_hex(val) + "\n";
}

// return a hex value LSB first
function lsb_hex( val )
{
   var str="";
   var i;
   var vh;
   var vl;

   for( i=0; i<=6; i+=2 )
   {
      vh = (val>>>(i*4+4))&0x0f;
      vl = (val>>>(i*4))&0x0f;
      str += vh.toString(16) + vl.toString(16);
   }
   return str;
}

// constants
var S11 = 7;
var S12 = 12;
var S13 = 17;
var S14 = 22;
var S21 = 5;
var S22 = 9;
var S23 = 14;
var S24 = 20;
var S31 = 4;
var S32 = 11;
var S33 = 16;
var S34 = 23;
var S41 = 6;
var S42 = 10;
var S43 = 15;
var S44 = 21;

// rotate left circular
function rotate_left( n, s )
{
   var t4 = ( n<<s ) | (n>>>(32-s));
//   accumulate_output( "  "+cvt_hex(n)+"<<<"+s+"="+cvt_hex(t4) );
   return t4;
}

// functions used in calculation
function F(X,Y,Z) 
{
   var t3 = (X & Y) | ((~X) & Z);
   accumulate_output( "  F("+cvt_hex(X)+", "+cvt_hex(Y)+", "
    +cvt_hex(Z)+")="+cvt_hex(t3) );
   return t3;
}
// do a = b + ((a + F(b,c,d) + X[k] + T[i]) <<< s). (note: <<< stands for rotate left)
function FF( a, b, c, d, xk, s, ti )
{
   accumulate_output( "FF: a="+cvt_hex(a)+", b="+cvt_hex(b)
    +", c="+cvt_hex(c)+", d="+cvt_hex(d)
    +", xk="+cvt_hex(xk)+", s="+s+", ti="+cvt_hex(ti) );
   var t1 = (a + F( b, c, d ) + xk + ti) & 0x0ffffffff;
   accumulate_output( "  a+F(b,c,d)+xk+ti="+cvt_hex(t1) );
   var t2 = (b + rotate_left( t1, s )) & 0x0ffffffff;
   accumulate_val( "  FF: b+(... <<< "+s+")=", t2 );
   return t2;
}

function G(X,Y,Z)
{
   var t3 = (X & Z) | (Y & ~Z);
   accumulate_output( "  G("+cvt_hex(X)+", "+cvt_hex(Y)+", "
    +cvt_hex(Z)+")="+cvt_hex(t3) );
   return t3;
}
//     a = b + ((a + G(b,c,d) + X[k] + T[i]) <<< s).
function GG( a, b, c, d, xk, s, ti )
{
   accumulate_output( "GG: a="+cvt_hex(a)+", b="+cvt_hex(b)
    +", c="+cvt_hex(c)+", d="+cvt_hex(d)
    +", xk="+cvt_hex(xk)+", s="+s+", ti="+cvt_hex(ti) );
   var t1 = (a + G( b, c, d ) + xk + ti) & 0x0ffffffff;
   accumulate_output( "  a+G(b,c,d)+xk+ti="+cvt_hex(t1) );
   var t2 = (b + rotate_left( t1, s )) & 0x0ffffffff;
   accumulate_val( "  GG: b+(... <<< "+s+")=", t2 );
   return t2;
}

function H(X,Y,Z)
{
   var t3 = X ^ Y ^ Z;
   accumulate_output( "  H("+cvt_hex(X)+", "+cvt_hex(Y)+", "
    +cvt_hex(Z)+")="+cvt_hex(t3) );
   return t3;
}
//   a = b + ((a + H(b,c,d) + X[k] + T[i]) <<< s).
function HH( a, b, c, d, xk, s, ti )
{
   accumulate_output( "HH: a="+cvt_hex(a)+", b="+cvt_hex(b)
    +", c="+cvt_hex(c)+", d="+cvt_hex(d)
    +", xk="+cvt_hex(xk)+", s="+s+", ti="+cvt_hex(ti) );
   var t1 = (a + H( b, c, d ) + xk + ti) & 0x0ffffffff;
   accumulate_output( "  a+H(b,c,d)+xk+ti="+cvt_hex(t1) );
   var t2 = (b + rotate_left( t1, s )) & 0x0ffffffff;
   accumulate_val( "  HH: b+(... <<< "+s+")=", t2 );
   return t2;
}

function I(X,Y,Z)
{
   var t3 = Y ^ (X | ~Z);
   accumulate_output( "  I("+cvt_hex(X)+", "+cvt_hex(Y)+", "
    +cvt_hex(Z)+")="+cvt_hex(t3) );
   return t3;
}
//   a = b + ((a + I(b,c,d) + X[k] + T[i]) <<< s).
function II( a, b, c, d, xk, s, ti )
{
   accumulate_output( "II: a="+cvt_hex(a)+", b="+cvt_hex(b)
    +", c="+cvt_hex(c)+", d="+cvt_hex(d)
    +", xk="+cvt_hex(xk)+", s="+s+", ti="+cvt_hex(ti) );
   var t1 = (a + I( b, c, d ) + xk + ti) & 0x0ffffffff;
   accumulate_output( "  a+I(b,c,d)+xk+ti="+cvt_hex(t1) );
   var t2 = (b + rotate_left( t1, s )) & 0x0ffffffff;
   accumulate_val( "  II: b+(... <<< "+s+")=", t2 );
   return t2;
}

function do_md5(str)
{
   var i, j;
   var x = new Array(16);

   // initialize detail output string
   accumulated_output_info="";

   // get message to hash
   var msg = str;

   // note current length
   var msg_len = msg.length;

   // convert to a 32-bit word array
   var word_array = new Array();
   for( i=0; i<msg_len-3; i+=4 )
   {
      // convert 4 bytes to a word
      j = msg.charCodeAt(i) | msg.charCodeAt(i+1)<<8 |
    msg.charCodeAt(i+2)<<16 | msg.charCodeAt(i+3)<<24;
      word_array.push( j );
      accumulate_val( msg.substr(i, 4)+": ", j );
   }

   // handle final bits, add beginning of padding: 1 bit, then 0 bits
   switch( msg_len % 4 )
   {
      case 0:
         // text length was a multiple of 4 bytes, start padding
         i = 0x080;        // 4 bytes padding
         break;

      case 1:
         // one byte of text left
         i = msg.charCodeAt(msg_len-1) | 0x008000;  // 3 bytes padding
         break;

      case 2:
         // two bytes of text left
         i = msg.charCodeAt(msg_len-2) | msg.charCodeAt(msg_len-1)<<8
    | 0x0800000;        // 2 bytes padding
         break;

      case 3:
         // three bytes of text left
         i = msg.charCodeAt(msg_len-3) | msg.charCodeAt(msg_len-2)<<8
    | msg.charCodeAt(msg_len-1)<<16  | 0x80000000;  // 1 byte padding
         break;

      default:
         window.alert("Something went weird in the switch!")
         return;
   }
   accumulate_output( "length="+msg_len );
   accumulate_val( "length%4="+(msg_len%4)+", padding=", i );

   // handle the end of the text and beginning of the padding
   word_array.push( i );

   // pad to 448 bits (mod 512 bits) = 14 words (mod 16 words)
   while( (word_array.length % 16) != 14 )
      word_array.push( 0 );

   // add 64-bit message length (in bits)
   word_array.push( (msg_len<<3)&0x0ffffffff );
   word_array.push( msg_len>>>29 );

   // blocks for each of the variables
   var a = 0x067452301;
   var b = 0x0efcdab89;
   var c = 0x098badcfe;
   var d = 0x010325476;
   var AA, BB, CC, DD;

   accumulate_val( "Starting, a=", a);
   accumulate_val( "          b=", b);
   accumulate_val( "          c=", c);
   accumulate_val( "          d=", d);

   // Process each 16-word block.
   for ( i=0; i<word_array.length; i+=16 )
   {
      accumulate_output( "Starting block at word "+i );
      // Copy block i into X.
      for( j=0; j<=15; j++ )
      {
         x[j] = word_array[i+j];
         accumulate_val( "x["+j+"]=", x[j] );
      }
   
      // Save A as AA, B as BB, C as CC, and D as DD.
      AA = a;
      BB = b;
      CC = c;
      DD = d;

      // Round 1. */
      // Let [abcd k s i] denote the operation
      //     a = b + ((a + F(b,c,d) + X[k] + T[i]) <<< s).
      // Do the following 16 operations.
      // [ABCD  0  7  1]  [DABC  1 12  2]  [CDAB  2 17  3]  [BCDA  3 22  4]
      // [ABCD  4  7  5]  [DABC  5 12  6]  [CDAB  6 17  7]  [BCDA  7 22  8]
      // [ABCD  8  7  9]  [DABC  9 12 10]  [CDAB 10 17 11]  [BCDA 11 22 12]
      // [ABCD 12  7 13]  [DABC 13 12 14]  [CDAB 14 17 15]  [BCDA 15 22 16]
      accumulate_output( "FF (A, B, C, D, x[ 0], S11, 0xd76aa478)" );
      a = FF (a, b, c, d, x[ 0], S11, 0xd76aa478);
      d = FF (d, a, b, c, x[ 1], S12, 0xe8c7b756);
      c = FF (c, d, a, b, x[ 2], S13, 0x242070db);
      b = FF (b, c, d, a, x[ 3], S14, 0xc1bdceee);
      a = FF (a, b, c, d, x[ 4], S11, 0xf57c0faf);
      d = FF (d, a, b, c, x[ 5], S12, 0x4787c62a);
      c = FF (c, d, a, b, x[ 6], S13, 0xa8304613);
      b = FF (b, c, d, a, x[ 7], S14, 0xfd469501);
      a = FF (a, b, c, d, x[ 8], S11, 0x698098d8);
      d = FF (d, a, b, c, x[ 9], S12, 0x8b44f7af);
      c = FF (c, d, a, b, x[10], S13, 0xffff5bb1);
      b = FF (b, c, d, a, x[11], S14, 0x895cd7be);
      a = FF (a, b, c, d, x[12], S11, 0x6b901122);
      d = FF (d, a, b, c, x[13], S12, 0xfd987193);
      c = FF (c, d, a, b, x[14], S13, 0xa679438e);
      b = FF (b, c, d, a, x[15], S14, 0x49b40821);

      // Round 2.
      // Let [abcd k s i] denote the operation
      //     a = b + ((a + G(b,c,d) + X[k] + T[i]) <<< s).
      // Do the following 16 operations.
      // [ABCD  1  5 17]  [DABC  6  9 18]  [CDAB 11 14 19]  [BCDA  0 20 20]
      // [ABCD  5  5 21]  [DABC 10  9 22]  [CDAB 15 14 23]  [BCDA  4 20 24]
      // [ABCD  9  5 25]  [DABC 14  9 26]  [CDAB  3 14 27]  [BCDA  8 20 28]
      // [ABCD 13  5 29]  [DABC  2  9 30]  [CDAB  7 14 31]  [BCDA 12 20 32]
      a = GG (a, b, c, d, x[ 1], S21, 0xf61e2562);
      d = GG (d, a, b, c, x[ 6], S22, 0xc040b340);
      c = GG (c, d, a, b, x[11], S23, 0x265e5a51);
      b = GG (b, c, d, a, x[ 0], S24, 0xe9b6c7aa);
      a = GG (a, b, c, d, x[ 5], S21, 0xd62f105d);
      d = GG (d, a, b, c, x[10], S22,  0x2441453);
      c = GG (c, d, a, b, x[15], S23, 0xd8a1e681);
      b = GG (b, c, d, a, x[ 4], S24, 0xe7d3fbc8);
      a = GG (a, b, c, d, x[ 9], S21, 0x21e1cde6);
      d = GG (d, a, b, c, x[14], S22, 0xc33707d6);
      c = GG (c, d, a, b, x[ 3], S23, 0xf4d50d87);
      b = GG (b, c, d, a, x[ 8], S24, 0x455a14ed);
      a = GG (a, b, c, d, x[13], S21, 0xa9e3e905);
      d = GG (d, a, b, c, x[ 2], S22, 0xfcefa3f8);
      c = GG (c, d, a, b, x[ 7], S23, 0x676f02d9);
      b = GG (b, c, d, a, x[12], S24, 0x8d2a4c8a);

      // Round 3.
      // Let [abcd k s t] denote the operation
      //   a = b + ((a + H(b,c,d) + X[k] + T[i]) <<< s).
      // Do the following 16 operations.
      // [ABCD  5  4 33]  [DABC  8 11 34]  [CDAB 11 16 35]  [BCDA 14 23 36]
      // [ABCD  1  4 37]  [DABC  4 11 38]  [CDAB  7 16 39]  [BCDA 10 23 40]
      // [ABCD 13  4 41]  [DABC  0 11 42]  [CDAB  3 16 43]  [BCDA  6 23 44]
      // [ABCD  9  4 45]  [DABC 12 11 46]  [CDAB 15 16 47]  [BCDA  2 23 48]
      a = HH (a, b, c, d, x[ 5], S31, 0xfffa3942);
      d = HH (d, a, b, c, x[ 8], S32, 0x8771f681);
      c = HH (c, d, a, b, x[11], S33, 0x6d9d6122);
      b = HH (b, c, d, a, x[14], S34, 0xfde5380c);
      a = HH (a, b, c, d, x[ 1], S31, 0xa4beea44);
      d = HH (d, a, b, c, x[ 4], S32, 0x4bdecfa9);
      c = HH (c, d, a, b, x[ 7], S33, 0xf6bb4b60);
      b = HH (b, c, d, a, x[10], S34, 0xbebfbc70);
      a = HH (a, b, c, d, x[13], S31, 0x289b7ec6);
      d = HH (d, a, b, c, x[ 0], S32, 0xeaa127fa);
      c = HH (c, d, a, b, x[ 3], S33, 0xd4ef3085);
      b = HH (b, c, d, a, x[ 6], S34,  0x4881d05);
      a = HH (a, b, c, d, x[ 9], S31, 0xd9d4d039);
      d = HH (d, a, b, c, x[12], S32, 0xe6db99e5);
      c = HH (c, d, a, b, x[15], S33, 0x1fa27cf8);
      b = HH (b, c, d, a, x[ 2], S34, 0xc4ac5665);

      // Round 4.
      // Let [abcd k s t] denote the operation
      //   a = b + ((a + I(b,c,d) + X[k] + T[i]) <<< s).
      // Do the following 16 operations.
      // [ABCD  0  6 49]  [DABC  7 10 50]  [CDAB 14 15 51]  [BCDA  5 21 52]
      // [ABCD 12  6 53]  [DABC  3 10 54]  [CDAB 10 15 55]  [BCDA  1 21 56]
      // [ABCD  8  6 57]  [DABC 15 10 58]  [CDAB  6 15 59]  [BCDA 13 21 60]
      // [ABCD  4  6 61]  [DABC 11 10 62]  [CDAB  2 15 63]  [BCDA  9 21 64]
      a = II (a, b, c, d, x[ 0], S41, 0xf4292244);
      d = II (d, a, b, c, x[ 7], S42, 0x432aff97);
      c = II (c, d, a, b, x[14], S43, 0xab9423a7);
      b = II (b, c, d, a, x[ 5], S44, 0xfc93a039);
      a = II (a, b, c, d, x[12], S41, 0x655b59c3);
      d = II (d, a, b, c, x[ 3], S42, 0x8f0ccc92);
      c = II (c, d, a, b, x[10], S43, 0xffeff47d);
      b = II (b, c, d, a, x[ 1], S44, 0x85845dd1);
      a = II (a, b, c, d, x[ 8], S41, 0x6fa87e4f);
      d = II (d, a, b, c, x[15], S42, 0xfe2ce6e0);
      c = II (c, d, a, b, x[ 6], S43, 0xa3014314);
      b = II (b, c, d, a, x[13], S44, 0x4e0811a1);
      a = II (a, b, c, d, x[ 4], S41, 0xf7537e82);
      d = II (d, a, b, c, x[11], S42, 0xbd3af235);
      c = II (c, d, a, b, x[ 2], S43, 0x2ad7d2bb);
      b = II (b, c, d, a, x[ 9], S44, 0xeb86d391);

      // Then perform the following additions. (That is increment each
      // of the four registers by the value it had before this block
      // was started.)
      a = (a + AA) & 0x0ffffffff;
      b = (b + BB) & 0x0ffffffff;
      c = (c + CC) & 0x0ffffffff;
      d = (d + DD) & 0x0ffffffff;
      accumulate_val( "Round end, a=", a);
      accumulate_val( "           b=", b);
      accumulate_val( "           c=", c);
      accumulate_val( "           d=", d);
   } // of loop on i

   // process output
   return lsb_hex(a) + lsb_hex(b) + lsb_hex(c) + lsb_hex(d);

}