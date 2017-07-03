ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1-unstable.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1-unstable.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data-unstable"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:unstable
docker tag hyperledger/composer-playground:unstable hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.hfc-key-store
tar -cv * | docker exec -i composer tar x -C /home/composer/.hfc-key-store

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� GZY �=Mo�Hv==��7�� 	�T�n���[I�����hYm�[��n�z(�$ѦH��$�/rrH�=$���\����X�c.�a��S��`��H�ԇ-�v˽�z@���W�^}��W�^U)�|��l�LÆ!S�z�h�J����0���MpL�/.���(��c�(�>`�x�� ��_mۑ, 8��Q���&���BZ�j�k`�[�(ZU��E��	k}�_�#�:��t���X���
k�LhiPi@+ҏt)�j�c�Y�+�
���[&aP猪������R�\�P�G�B~#�Y�y �� �X�ښ�2t�*T�2��5@7��T�T�~L!��7�'��Aq�&����ɖ-��$0��e��t�03��A�^�v4��v%����4��k<n��B	�a4s����RFf$ְh�^���Ł�* )ږ��hX���x���Lj�#����#I/�Bގ�"7%�B$�V��c�e��4�)X6W)�b�Ҙ���8&�\�����dh�A���]�0ajՂ�mh;;��@��<����9��h/!����i�N�F�U���eAQV%mF�*"���y��;1=ڠR�|�]�j���/:]�:!Ï7Z��<s��KZ��<\��� nC��	����ȝ���|"�_5�c��>�@�������sN��G>��iJ�btuw�
���� ��_��,���g�<�8j�D�K,��y��"5U��$�I�Fے!��<�B�(���B��.)T6�*��rJ|ü���3|�50�
��i���}�Y~�����?�}ܜ�*�lt!����0F�MI>A���m�wB��bW�X������9l���؅�����_юv��=#Fa�L8��6�fBTH���u�8��IW�����:P3Ll�A��� �mᵗǀi���<:V� ��4kȨ�bk�u��H@��	C�q{h��\.��f�'rSB�Iw�IW���d�%�[��&��jVV�~e�RH�T�7&��fB�f6�pA�#^��M8h���?C�&�����j���UM	I��T;�%���L
�?؎�nw�� $ȗy��N�-�$ģ��K�ph�q��Ql8���(��^��PL?M�Ч.s�׬�MK�۪݁��?�A�����B���o.���� ky��։Q8M�'����ڂ-�Q V[�U�q�)`S~"�1̧ϨwUdן<UH�B��(��`m��"�u@���K���F(7@o!z8o	��C�5����ۚ�-y.�'ə���87H\
R箤^ƅ쓟���$C�c��7�
4��FvIl ٠Q~��(�Ί�L{�X2����̻i�cZ�\�v3�@S1.�+����g�n8��͸����g6}F{�� ��z��k=R)�:�й1胘��.���Z��/��]eWj�I�yW��s���\�X���EJ66Ԡ�nS��� ��Д�i�?%|HeCګu�^�Ә���2��@�q�y��)Z<�DL��j����۩�	<#"������//�(��nռM@XCx�Lu�phK2�:\L�#���q'�3����?q>�X��������e[��	���͞!�g�����#�/�/�f��iiyڰ��U1��h
k�K��
Z۲ph�@��a��t��~�ᄪnf+G�T9[����&�%c��=������ _,c���:G,gSG�b��-䟟]\�̞�;� T�u:/��n�[��끃�ϰ�L��9�PP���y��R`��`b�TF��T�r���͉����\�����S��R�g#EH���n�Nh��埽aB�o�?!^Y�����7��X��?O,޾�r�(�W���H���nՠE���^��8-��	���ZQ'C�xC�gE�����Ѓ���x&�1㿌V��<ϸ��3��X����q����d9w� �$�Q���1f!�󀻗��M��Ǻ���D�@(dZ�����<�2��f�Ũsk#�C���i����`Q���s0���
�	�o�&��^��?�,������s��I����?\��-�?s���_����-�в�0-Uw��VK�;L�xv����ol B�V�m��ꑼGw$�m
��=ہ-���_��yF�WY�F�Ӎ�1�9K��n�"}Ҫt�dJ:��wa1w�L���t��>���5�<����(�BV�<���]�UyY��\��,���t�q�H�O/�7w�(�̨�s�B�����G��Ŷ�i�H��jq@�܀ѮsA�&N<��	FuŞ�ď�f�L?&5u��1]no���^�o�-<q��E�䟋'�?x������х)`�^�ˢ�Ή�23�	�����Y�]��0x����'��i��f>����A����m�I����G���x�;��+WĞ���_� .��sI�N�nB�,P��o�ba|7+��(����	\��?ӂ���n�fŻjg�n͐%�i�N��rs�5x�ir��f�vn��;t�̓w���x1���ihjFoOR����2��U�'0ɢH���P��̃s�ߏ��)٠��5���������"]����]�,��au{Z�?6��?	&���ހdud|�͘{���p�G���x�"�ղ{i^!���cn��Isb.)�+���QJ8�?1/$���:>�	 �1����#�8�r��r �%#e0��!\0$JF��q�@�P���X>��X�;�BZ���*a7���C%I�|u���gh�t$+b�uO��6�L�]�d���Ѷ�+n����Nf�p6��jd$���=Q�1c�ō2�:�ve����)g���xB����J�mWGCE�B?�bu=��7[��q۬U���'~�t5��M����Ah�%�]��sɸ�;��nA?�qM�6.��a��M݂&��c�����b��|��?�7�?�+H�h�W�3��\B
��qz@v��z��ٿ� Lu�Xe�
�2�l������ ��o^�,z�d��y��5��t����hZ�r�;w�/��L����n���j�(Z ,��y����{S�B�s��(�f�E��$p<���xvp �xJ3�-� \���<
�k�� ����+���c徻����os)�d�?62�����>����8�`+@߽ƽ��iR*Y�A�ٓyק߀�і�JmL���Z��ͥ������hX����_�OV�-U-��t@�gB��/��Z'��<�����
���K$��?��¹X�_�������r�ô^n�:�Y@Ɇ�s������\�=�>�A0�%�c	���f��=���L�
��N�O�����;��p�OC{�lx�xϭ?�2��p�K*���S���D�X�?ɘ�P��#��t��ĸ�v�{���j���
�o��&�Cy�mb����o0��n�e����;�����n&���Y��|�����4�	�?�A��?���\��7	��z��(UAa�E[yo3���:�wTɽ��F�PG�v��@�?��Pz�m������!�U��W�	V�P�ո�T�B)�Z�6��x�c�J=^[]��������\c�"���;�p�-D>��-G��2�;�aH��l��r5��M	U���l6�u�J	J�!t�I��-ewK��ή��Ȟ��[�&�4υ�d�q�<9.K��p���Jv�PO��ӻ�RF���9�9DJ`w�T2�U�6li�#�xs�*��%�<��w��vV<���{���:\;rI�M�̕j�Wz��k0��ș3m���Ԫ�8�s8K�]�,.0���Y�X��
�a��۰�P)΅W�F~7)�Wm��+红[���5��{g�Ak�Wki�\y��!��M��V��b�C���j�ZyS��\y���N��Ƀk�N�����nl���2;�}n��m�t���桾edϏ��P��z�i�$�KAL����I2ZS�L��}]������.7
0�|�u�P�܍�D+���N�]9�o'������n��уB�<���q9���ĥ����t�Zf���Pڌ$Ծ��F.�����*�r9�ȤRvF(�l��O�.��b2�-�r�����u��q2U�f�a�\'�g����׊ǯ���yg���dX�]�"^:����M5�R��"��rW薅l�&�n[�F{��atE}�P���VF�`���Jz_�V�Ӛ�0�l���;�R�d"�WQGS���ճ㍎���xE:�ӝ�N�ID:�:1�#����}�Sx?��#?�6�ƶ��/����Ot�������R���������o�sޤ��S���w۹;�_t��/`>�?A�g�����e���O�N\,gwѤ��}���e3�BC����f*��*����+n&3LW��r�Ԩ0���`5)�:��^��e���ʫ�v�X��}Y�{��T~��k��|JJ����+���p;�tR�ʦQ��Al��Ǌ���U^7�[<U�rf;y�\�t,����{�rEWN��\�UDGz`�-E�G��ь�k�Ác������b�����߮�w���Ø��q����7��;��l*8�{���cQ}������zp��k�3˿��vΦ�1I�,?l���?��_}J���>{��>�������!�������]�2����a��Wa��J��(<���Q��G�	6�F�$�����⌼�r�_���,��~�/�!������<��?�������������3/�~������%ѥ��3�'�ij�l��җK?�~\�\�R\z��`ɏ/i�J�mX��n-����E�8\�~�O�,��'�Y�}��@>�/���{鋥?���%�����(��{�� 9Y���G(�s? Ǖ!��:�|��0�K!ʯ�����?������������'���~v��K����i[0�y���Y�op�����a�o>���e>�=����e���KI���A�������zH�g`F����OФ�#�E������)�$���]�����b�[�� '��{
\����4��C($�����L�{a��F�@CK���"l��	�͖���m�d��'I5>��A���(_���묒����բ��*����j\��V��ť#��j����삐��~0p�U��=�1�Ա'%]=���$�q�:{�ɤ�3=�(����L�遅n"E5��p%Q��E���*REQ*J:�!�����࣓��	Āa�	�� 9�=r��CJ�*UI�tWw�<�W@u����������q�����6���f5�������s򖼈h���)��O��x��^�e��V%��b���
+��aòW�i��b�����UˈG�������,�J��<Z�^��/��,��8���8��
?r����Gz�����D��X	�G������;I��x�~8W���@䏺��yl����A8�w�pd��;�L�mN֙˜���ϭ���ۄ{)ޛ�z<bg�ή��-�.��5p�;	n�-�<?DO�������G��wuU�Io�\vc��7F���������W,��}.\�6oI�C/��Ѥ�g�����sB��Y��U���0go{f�.��-L�t��/r5R)l_�ɳ�[N=F��,ɵ]����O�~j���%�Bk��$�Ш�Z-�����a<�k׉g1~��k��G���i!vk\I�qOS<1�G��Y褥�
�N�ܘj�J���+Tee94�+�ҨJ����c����۹9d.>WVH�]�fH��H�}D'�Xu	?]���Z�t���Q>.��rD��y6�u�I^�����-f��^��p+���3��d�4�"�=Y4Ϯ�� ��n:�� �~�š��_�_Lkh��qlx��6#f��h)	�m����l�+��q"q�b�%�q]*?���՟�.{1=��	�G�~
����������G�|>���}��Vx����?�����W���?�����w���w?��|����{��M:�ou�Gu�u`���Ko�t���?~5�����.��k~�cGu۰�0t��rY܄�v�ng�V6�¦���@<k`h��ؑ%P+� l�z�0�n]�����W����?���������_��W?�����������'%�;��N�ea������-Q�?��wNc|����|>���N������uz���\�$��2CӤ��Kdm����q!4�>���q���J݌�-�]f�vZU�);'�e�����JG�z}-M�v�����0j|̥8���'қk1���d����Zsv�jv:z�
[2����#,x�-LQ�cTň*Lq&(�H��H#��[|�|�Q��8�$�H2�o��lg�Z�%��P���.�f���\�@�U�l:5n��%'r�yRnτ��A3�6;h�'gHƆ�^�?%�!!iF@��B�d����k+�@ 3��_f����95��V2��β)R���M��(��S�����$P�M��B2Iα@w�tD��i��&��,�X9 ���:�W	Ӟn��XYO��@*�n�;���T�$C�I�%GDY�5D�[	���S��6�+.8/QR��CEb��O�t����8|��G�Ё����]-�c3��}�(?��G!�n�m,�ԧ/_��(=YU�\UQ|0�l� v�JI,!������B���D^�Q�c��+���<R$6b�U.:ى�VC�)�T1א"�d3Hm� �C�CH
�1���՜\��c:����Ӱc�a)���Qg�t#G�I�wd6�tV��� ,Ҟ�Qu�*�'�RK��&Er�>/AU���|^�OD	�Z5P�PaƜ�&�
�b��b$j�&�3��]d��|�%hrH���Er¥����JM���Q>���!��M��*s�l��m��D���,%Üt�Vf~d�R�By�^)7h��+�"�x�%b�x�Saa���\rJ�����N������>0�e�J� %Q�;�jG4�̊Ơ��Ԅ��mx05�%��A��S�2߁�� ��zk8����?���bOP�f���Q�^\TIyЫm�9�3�
Ka�!�9E%|���#�(m?W	�&\�W2l�/tHx!,��ݬcAa�N�L��*�f�z_l�Qî"x�ҙ��&�˄�O���7)�nZ�ܴ��ip�2�U<�M�x���� 7-�nZ�ܴ��n��%��zxY.�H��7����߃N��=��/��I�^��������l^���3�����_���v½���C8�����nr�S���7N������-��O量~/�'�N^m�K�s�{E%�c)��4F>�����x�}����u���khR�ה&���Ү\�	p��[-Ug���X�<(hT�2�gkR(V��b�7G�a[�p�L]�i�����4f����|�;�)j���i��z0�&׃��+d#Zmj�vXAs���^��w�t)��~E�"@�kx��}U�f?[��&ݑҩ��:q���N�i6\o�f^&��eBɵ�`  <��%�A��X�s
�~_�jB��6�\)㖘���+�q�b7��=���s��	G����Sf�6�_^��Z:Q�#�؁e3"��#aL��ˍ#��Wi	���z���]S��z��^��*V��*�R2CHCS�5�\=�{��	ͩ��Ə��\�b��R3�1�̌V�v�&���p����8��"]d	P+VӪ���_7_�TA.��|��e*MW�J�Sxn*yR�<��E���Cx�^f��I�����k�Ro�^?�|���YΟx���>�\|�o���t�' �i�@�>8���������<H}����߾b*��g���HU�q�ri(=)�."�L���[޳V�y���7��[����r����U�'�N���
�4���*�ڣ�돶B�c_2A��y���J���x�S (*J��$93����@���Dź��]���=g0A=M�F��5|�S*[�Bm�鞊�|���"�s���G�QkNV�q 
"�Ա����"n���(*v�I�M�&�x�#���z!6���)	<Y��!Ɲ99\(m1�����-��k��E�my��S�#��#�=p#s^�90I,v�2VvfY��4��2�B���5E�z�4u@�f�C\�͝Ճ",*,=�� �FEn�݊^�1?@�v���.��|��x���gɽ4^���d ���z趚��M�0��X_ C�c�%������(~�\��Ou�t5̀:�+-�3��`���y1��/��\4c�߀���G�.�K�T����B^m�U���,nB����( ����zD��BDtBk*	�F�dż�8�l�MD��tYRfӡ�Mך����V��5�rWS;�	�[5{[u���uW:����F>�n����0~T�U�4�'��.��>��]��>�~�c�����s�U���}��3����w��{��+!���Q]�`��&���!�2Fo�Z��gw�#�<g�Ù�FT���� t��(O�p�`���c�57ʺ=o���T<f�J�&��V�z���~c���X�3eH:�jͣ�-���c�\�bHe���u$֑���X����h�,V�1֢�t���z�W���]溣q�Њu��(�,Y�ꦇh�kC��l�H�B]�Kg��1R���Aܫ�T�+�*m)l���QS!]�	 ĕ�Cm�V����*�-U3E�t$��H�}���L�4��A�K/�ע�o�^_�쭟t���I�I���D4��UDS����]4=Sǌ���Kr�A8	���J��zx9�{��i��T{ltdwn��J�v ���'߃����k�y}��,�v�~>�s��"�?�����逽s�x��x|�9WM��s<F>��2�*��U�=�\�8_t���zx3��w��=Ǐ�:�T*�������/.�ʹ���	�x41�����$�/������!Msd���~-u����/)�z�q��?��s˟�����z�ĵ�����3��������o��l���?
!���۠g>�eSO3�(
�������0x�����w�����Vs��sO��6��)�G�=����G �<�cYt���A�����������=���at��{���1�/:�%����nh��{��9�c�f����m����Ŏ���M��@}F������p&^��������Q�E��>
w��®W��;a��[⿙��w�c��h���������;���}�Ǯ��������C�M����[�}?�]���|���zI?�	����������ڱ����r�!�������������mН����8�s����g0|������m�U�yс�?����`X�PG^i`3nH[(��g��ן��ot��7��<rr��\���j���3x��nA���z��)�jx��E�i39�ob~��U��2y�IU�t�( FvC)����tG��Gy��(���(|q<��#>7�����s}P�Na���?ꎏ��Ɛ��Rpq� �.�8?�+<���Χ����EM��M����x0�Eh"�FZ�k��&J���kAsr�f�ՠ�\-� -�Z��(�^�Ϟ��o�X���A;����,�#k�������m���G��������3g����b���8�[����t���%��\�q=���X7�6l���%��m����������۠5��&��ӹϳڱ��b���l��⠨��D�I���\���B�@,F �X�Y�Bэެ2'���L^ "���l��Q�c'�S8��ff�р�g�̚ղ(�ί�w#Z��@Q�|�`TqBQQ}k�ֽzk�JΉ��ET=�TF*�����gٷ�Gyh�)Aݶ�mF�l����ܳBߝ7��>�g��VWwh�?-�ӛB��c��域�0��o��I�_���?��H�_`������7B#����Ҕ������������0���0��P��Y��t���tŜ �Y�1��<�'I�S��SQD����D�q����E4As��������S������/,�a�ֽV�hRl��q�s�H4�̯b{�G�k+޺����Þ��(���ba��ڽ2�z�[74�bA�tU�B2�C�MYgnO=i�s!���� ���U�w-��r�"��/8<�)���C��W#���o� �����3���i,����WT4���+��������_�����Fh\�!�+�����f9��5�C�7�C�7��_���k�f�?��������A��W�a�����'�\W`�Q���'_���n�o�%~�۟���[�Yo��٦,~t�u��k��0}-�1m}w۵9]գB�?L[O�}����Z����?�51�������w6���;I����r�ӲB\.�ñ���#ų��ڗjx�e�������(lW�ܬڧ5�]8Zw��5o����)�BqM�����r�_��r����ɱ��Z�k�N�MٳI�ڶb�u'�l6j�ʇ鑅�J$���\���W�Io��W�"Y�ڇnubfeǈ�e0�]a��H\V�c�(������d����f�f<�����9�L*/������+ ����B��j?��P����w����������?��A��H�GC�'p������7��i����=�΀vZ��ڝwg��'cGܮ=Z%m��ns���V��i�r����^R���`�]l�2J��n���������l�M�
ֆnj�$'�4y˓��z����������+�|pal���T�on�h'��(�ɓ��MYm�12���w����{%sQ�r0��R�܍5�j?�|��$yّ���{o�P�Q<�?���������y���翢�i�� ������:`��`�����y��a���������^�����ρ�o��&_�2��MД�������x,�����S̳���M�X�!1�������}1��#���2�����G��8X�kX���?X���?��������}�X�?���D���#��������������_P�!��`c0b����������}���?��O��C�W#|���?5���Ƭ��:����͡��~�(�7���/��������|/���+��_��]�8�:�e�I{�8�����fg�b;z�1��χ^���ښ*�O����t�Z]T�Y��3e;�dEX(������www��������7���r!�f�҉O�g+�c�}�<ܼ��?�S9e)i�6�����mwX�B�/�b?��s��2���P�#�/�q��p!-"]�V�Y�ع8�m��K�~08,.r�ұ��봥Odv�Yӎ1�%�(������2а����?sP�5��o�]���G���]���̫�o������gl��D�(�L�?� ���D��<���dEFh�Y6�E�fY��$J��[�����A������|��'v߻;�Z���뽻�T��Ҭ�d=z�5_�c�+�G��v��&�$�X;u1#�����z26�[ud��:��*ê����l����T��-��cB^,�}Y8��7ݐso� -"A[o�BO��09'N�0��6���ƚ]�̟��M���1��?���������؁���:����@b���Ā���#���@>��?(�a����������� ��?�� ���������@&����߷������?�@������Ā�������F�__ }�7��r���s����[��(��g�o�=��`B�g\h��\�������ᛉ��8?|3����5��Er֭���&�fѿ��|Mg�������?^3�Յ����ǎB8���Դ�Z����Z]��)g�o�����k=������	{;XěQ�У�i�u��?VUe��t��W��3H.Íǆ>UǺ{
i�hvW�V�=�SW�#[tX�9Q������wW�h�k=������-k:�3������[7P�u���wo���V���l��:����j�9��hi�r���?�MN��=W䇳�珮�æ,���Q��v�w\1���״�=��)˵Q�*q�.�ұ��N���y�W�=�9�zRt,�ν@�v������3���n����D|�*�v-׶ܟ������)�tr�.!�
������rQ�k)��%Iv�*7%\ۚ�d�<`��� oҥ�+'K
1�o����H�}�]l�w�E���@\�A�b��������t��I�)/PI��qL�Q�d/�\$R�$<K�L��$�dF�9+R4�'yS)�I���s������_���Ö�M��=����a7���f�iD��LO�q�-��)���Ԡ�-�.��;k�J�Oʨ�ܪ3�%8v�yI?�}������C��J��C9ei�]G��MW����ۻ�NQ������-~��E<�D�ǐ4�M�C�G�Z����Fx����%���+M������ ��8�?���)��M��Eq ����C�2�?�!����sO�?�G�����G��X!�a �9�����eX�k�����y�����te����H���3��t��ן��mo�;�Ĺw:��|��v�]˝�j��gsH��,W-m/g�VӶ�:�y�����ˮ���2�I͍��v�f�����W���6���Cm�2��~(�u�P=�.I �L����_��<�8�0ew���G�ƚ��n˒�Wj.r֍R���&j�7ʂl���;7��s����Fj��`�	;
��2p�=��}���!���?��B���]�a�����L�l?"p�����|��۷����7�.�i}V��a���%����'���"���� ^_��_�.�
I��T���{5�J�g3/V7�8�
r�J�2��]Ycz1͝Ӳ��2����Z�p~"��t`L����]:M�)��s'|���pM��O�5��
j*���6���K^�)~���ɪ��K�v��ȱk"��|5�m��L7B�^Z�_��U��iޟg�<_���v��JM��e�b��Iz�
\�ܴ���.�,�?��B�����}�X�?�!�}���?����_ ������G�wj|���ǰ�b���2�#V�T�r����?���?7���['�|���'���s���Ҫ�3��ڗn2a��.�/�C>ݚ�1^0���ǗǄKenS�j7�x���u�s4�~=�,VK�&e�4���)�B���������_�8��7���r!�f�҉�w��������yV�<s���4#��M֛�g*aM�EW���ɩ����N<����vdr.����[�;�:�ȵ����6[f����ѐ^�˙QΦ��^��"��s"�2�9ٚ�չ�R�r�V�\r�nQjIW�+;�귱����!q��_�����?��Ё���T"Py�Hɱ�@%b*�RΐtD��Dfd&2YL
R|��#���GI� ���s����8��~e�W�^n��.£8,;b���Ki0�8;؍�I��������N��La���{���F��^�N�$w�\��T�:��>Ɓ5��$�H�\�֋�up�KS�Y����1�̒������?������n����$s�/M����$��	��Ax�
����U]liJ�t�����5���7���7��A��f�˳)Ǒy&Ź�	�(	|�朔R���Ibα	ɉ	ñ<C		�pyL�i��4������?�?��+����)�XI�]߈���әl˕G�z|���ao�_����Fթ�o���jm�xLӾ��\���Iƺ�ܣs����w.Cv�f���ˬ��tx���Ί�]o5ڻ���^px�S�s�����Fx{��T%, `K��g��,���X�?���hF�!�W@�A�Q�?M�����и�C�7V4��?������� �ߐ��ߐ������_�����b�q�����p�8���?�~�������f9��M ��0���0��v��Q�L�1߸��}�8�?������: x��}�?��������]���_Q����S�����'�&�����#��4�b���o������?<P���\�)�Y���&@���11�������}q��������� 
���]��`��`���`���`���?�������B�Y��@&����߷������?����A����}�X�?���l�r��������A�w#@�7�C�7����/���q��ʮ�qw���#�����p��z1���p�.�D&M�8�3���\��,�b��8�L���X&a�$�D$.��d3!X���Vo�����gx�Y���M�����}��v�eh�g���书|m�Y��:z�,k.%�c�ں�T��;�"g��g4��灛�\P^��.�"����[���J�S�t��o>d$�TJ-'s~k���Fn��َ�<��'u�=a�,'��j��n6�X����`5�e̓v2�Ù�)�O��}©glv�V�4�`O2k�^9�h����JL�>�[�>�gSt�F9+j�|�qwO���g����t������(����p���;��A�Gg��A�G� ���s����?�Z�@���Ow �?`��������_��t��?�����������# ����������� �ׁ�������z�� ��3��_ ��0���	���
�����q�6�C���Z.K��.�َf�B�@��/�Xf�����V�&�գ�hY�+��@:��$��`/WF^H�����h:�7Ô�r��lb>����xcmژ��/U�x���0�_��'kV���S�;���QS�mk��I,���T�2v�Ka6e5h��8�\��S�e�OZ��>e�Z��湓����k�.�B�����б���������� ��;���hH�C�gũ��b�p8�H<&c���=,Bt�yᡱQaL=<FA�ǯ���?�����@���-�œ�g!�T���G��ϊ����,����v�lur&�ӆ�����x�d&��Cm�����M�FA;1�G����c^o��4���5�g�������8���{
����y���8
�_�������Q����O������Obx��@�F�������>���9D:��!1N"ѐ�q��1PC�����c0�`��d�F4r�w� ������W��?�����ԙ��`�\ώ��6T��l���7%.E8�J�n���m��?vxJ��v�c��#��l���e��%���b��$H�z�C�lF����*1��?��Cn�y��[��Jy�����}������/8�m	m�?h��/ں��������D���V�V��&���ʯ�_nV�̓���ਘ)�NL����r��=�5X����}�,e荘�4V�M�W���=_�sz���J���/�շ&���>��-Un�eM�~R�^��K�ϝu�k���q��ꦟ�_P�7�^h�3/�Z�ʳ��H�sc؆�&��:���,{}��������y�fq��8vٰ�������	q��	U�|K�
�k:�d���T�y��S�6U�ٰ���!* ��	����Jr�3�iB�R��p�
��,Lg�ʕ���(��6�l�Ҩ�d�#�n<ەXs�HGg�j�"�E�]�AR�^�?���j���M ����B�S�?�hm|�A�o����濻C������m������ �������'�������{t���	����>����g����Fb�������~w��W��l�e�r�n����0-���T��9O���,���ƚ�	���j �s%���,�[{'��O��ؕ�/�X�d\� �gT�����\��ˌ���u����z��~�I��*/��YY�.?�N��\���\��X��C�e��2��S]#�C����<��&$`UQ�'b�Al�)/���غ����k	���yF����i�`S���0")��SOIX����3b"����ݞ;�|~������x�o�?��mm��A�o����}����C��_��p�zS��-�����G��oo�ο�C~�����Ar��ŋh�,����4W�em��9}��+m��u�7Z&6�i���ۿ�ث���8p��캁\�:/nY?�;�n�i,0x��H�	c9H&cQfCs��k~�A��R�w�� �9|i��wy��|�ࣵ)�9&Z�f�:�Y��M�K��De����Y�}��1��9�h�_�����w0iB-��#"V9�AvT�c����k?�a�!N��x�Oأ4�Gg�4��X��ꈻ{^�W��U�=���Ǥɦ"�M}o�1?E��)����e��)6_؛���X&P4�K"�����;B��h�����`�M�@�����?������Nޛ�l�z\��*�t��A|���������|�����ޡ����	� m�4�[k���\�##i���<*�Y��9r��j��e��1��Np�؋��Ul�@3��W����������|�x�˃E*%�h��t�1a|*ӊ�I���ҘP�w��a�
��}����C%�k�lyJ��a�"�/S�*��ZB6-���1zJ�D.]���kd�G~�;ML�PXB����'���.B�?��Z� ܻg ��?�����������߃�0��
�����?�A�!ԃ�/
�_x��d��o����({5��4�U���j��nE���ۯ[�!������۟�3����
��\��g�al����x��?�#h[*��q��ַ6*�n�,s�2����'(Ց��X8c�\�����TB'1������a�Ut2��]��ŏ����?ׁu~�J�X�O{3�W	2�6�K���j�D�k]��ŝǻ���gd��*8Ѫ�s8��YB4$I�0��3��Af�p�6���C�=����[AW�h�~���A�M���V �@�����O��`��3tZ�������t�?<�!������;��9X>�G��u�r]�4��l��%A�������hqG��{��
�Ȭ��V�lE^#^��$y���1���;�c��jU��,��=�!YUUJ�Xs��ߝ�}w�7������`ju��2⫧h��l�.+����4.��l�5�>��/�jI��=~�(w�gRJ�˭�Z��0j��OA�����w �E��U��/����& ��� �[����1��#�����7�����Ow �P��P����?��J������Xݾd���ߡ�����?� ��z���]�'�`���@;����z������!��i��m�+�;������;��n�'�����?(
v������W���V ����������kS���p� ��[���������
��`���������������m�?0� ����_/���q��m�{��{���^����ǀ�oo������W���`��*'1�GB��2�������G�����~�4�F�+�{?�޽�	���� �*�<�<!��aZ���Ys�
?.'YV�Q�5-�1\1� 
�Jd��9YN��NDs�"�y�+_f��ɸ��:�Q!���o.EAx޲�z���z�����W_��r���ɬ�I�C�z_.��f�QX�H���2�d��쩮��!�����*��D�3�-"<�]c�#[7�T�t-!4Ϩ<_�<�l�RsF$e�w�I �K���bcFL$V��s�/���B/�� �������_���8D��w��?���������ϭ�s��b&b�c<��1��(/�i��S2萤P/��0��8"A��WkHF(=�����?�c�!���)���I����+�?7&���|�E����W+��(y���ƻ��z"�0m�K��D�5G�P�:��G�2�:��6M)̽�{k�����<�����*T��|�nW�7�渃x��	A{���/���el��|�8�-*����O�+��pT�$���D�j��T�/x�Ї�?J��?p�o	��?_ ʼ=E����?����i��A�G+h��?�� �W ���k������
:��9 �������0����������?�����O+ ��������n�?����_+�T�����������A������������0��6 �@���O����� �ϭ�S�B�:��[������� ��%��<
N�@/������o��/������k��2�V�3g/6�N`���m��(����i�/��I{
��&�Zge��S�W��?��<����������"�nO8iz� �+�)ɇ�ɘ��eAE\�#Re���9�ks����S������"\�K��ř훶�a�K����6B�l��7�α��&vr�J�n5����/%�Jb��k���s�_|i�ի#�_|��zs���z����Ň�yL�����h�MU�Wےr�)Mh����x�����Jf^f�3�& ��;b�m�1������J���*N>���z���v�N�����l������`����#�#����b4b$�P1:�I*�I��F�.r�R�p(N1a��$��_E��Q���a��[���B�!\�Mi0�EeE!�9�;���Ğ��]T��X�h������Ǜi�Q*�t���$q�r�ΡlOH�d����8��grB0� u��`�&�\~��Sc=buҭ������z/����}J���#���?����Gi��?���_;����~��}�ZC�?>����T�>�顪?E�Cq��O�C��?y�ͧ+�o�]X����_�=[�#�U;3�ٞ;;�C�ݙ4"��23Y�cW�U�[/���G����P���lW�]���j��@�(!(��C�g�J�$DY)� >"H,	D(��_|D$���B���v�fz6�%>-����{�֩s�9��s�#��$l���Ȩ�E��p���9Ԕ@�� U���<;����#���\�D�|�_9��X�w^މ|d'r�f����*�,��t���J� �:JW��Dv��H��8wf�^Du|�����]5|N_h�;�H~�jÞ��0���ȉ,$$@3mE�w�%�������plۦmDz�(h�O�_���7�"��u��H'�y�pN�'X�"
w�'�;��~[�Д�y���p_^O��Sk�ёC-��uud��z{t	Ơ)�+����W�i�^�B�%����������#AY)g�*.��ƴ��P'���C'�:A/��N�մa����E�� #�r̻N�#�8��*��l?x��F��WF��
��hУ��i�^����	e���> ŝv/s(Kw��ޝ��:9ީ9f���N���S0��H�FL�ý�p"o~��]����o�߾���?���~`�Ҋ%^xNk
��*�*Z2�d�������HJ�
�%����.+mTW�m,������i,��"��0���<��������_��������~����p_�^?��<8�)T�>.��3��zچ.���B����/�l�����i���/B��/��t�+��?w���ֹC����6���B�]ݺ �����uOՇf0�{�3Е��Ҫ ��4Y=T�W��^g0�Vd�����߿|�?�����_{�nw�#\�ο
]
c��h<��.����N0�xw��<�[N���,����G�?�%6��� �َ\z��?}��v��O���߿������w>����X�j�_#����"xC3�s��s�߿��G�7
״M��1,�֕`�P�vBE3)L�u9��IYK%�����Ob)Md��FS鄖D�8�b�@�o�ܗ��ϯ|W����ٷ����?��W����%�{�G���-p�@X<譛Џn� E�z�������O>.�����ֳ��>{P������a�����6��I������}l�6�cqp�z�q�7���t.3k�����5v�N@����
�_�
3V(��%"���Z���2��[�|r��~Q���
�$X��d=�ޚ(}�m
t�%j�G��eɎA�n͚uԒe�=�[,�,w�Z��6ˣGs�W8������N�8��7_2�D����e�d_J�Q͹T�3|����%y�z�j|F��F'�a����5���u!�C<\�A��U=�ay�qen`�a��q�p-��Hs�E���ap�5�l���o�'�
#�,�]vh�L�$͒����`(���e�5�WҪ>�Ơ�v4�p̔�����a��\�)"��4>L��di��-*������0��	.SJ<���������S�2�A��l'^!���m�:�l`'O�	g@�&D����9���*�J�,��*��1	��4���%#�~A�I=���i|�ì�k�/[���a�8\f���mKOb�;>hե�ru.b�:��HE6��
9' ��x�T��^{Df�-�*9��W�єMԈ�(e�(ew}��b�^"����Eh����FZ�E�o�Ϥ(�x3d
����mQ!�&�����s�j�f�P�F9^N�I�c����M���ȇp�N[ �-8K�d碱�,1�8ǆYo�h�$�n��V)�MU�\_N�rp���)�;Ւ�s�2a��r�N:�^���Ea�t0m<(��g�11�Y��"�G��,kd[�6P���R�*1�&�X�}2�H�;OKĘ��e؞��D�U��g�z���e��r��rg:跙Gc��c%��cr,]��aY�I8o��ǘ��!�S�%?L�֘&8l�%��V`���dD/���ǹ�#$�R�����Yfs�!�����E�2�����~�%�u��`�rg��.�b��W��+ܷ���׵�T���.V�Am2z�w�Gf�@хz�4�.�s�Qt!8��(9l��'���6����r�%g-ΰi�a�@�����&���Q�2��v���r��7�<S�$]Ѳ��J�$I	���+1���0qް�g���hU�9I�(������籁��l���������` k<֫Z���O��+�GbT����f%���������M��\-�U��R�T����p���i�i�2ʠ���d�B r���M��QOe�����N<^S��<��Ik���S�����
���8]�����Rt'~���5藂�uh�|��zb�r�x�3�W-��������\Y[P�+���쯉�v���2�oW��߿���+K���+��@_�rP�p㝛1�+�D�(t4��F}�X�I?���0�g1ޏ!�ߌw�,��1�3hR�i
"X+cEM^����j�ZR��WS#A��z��a&U�Z�:?6��p���8WL��j��L_(2B}FK�����N�I�b���7{��u5׃�Ŗx= ms�g��WNd�Ǎ�|`���~Ն3p�<�漉y�ӗ�#S���٠�Aw(tļ�ٕ�Q047�F�n�X�V�<.J.My��u��f&�GE4��c�Ǭbq��O�}N��"���3ŤY���v\��cH�S{j��Ul�4WDCN�x�$������ekb��'�Rs�>�t�F��F(5F�|}"���C|7+���rqZ���]�%�wR�r]X����m#E�K�6�ܬ�̈~֢�ۘ*�T0�z�tK���U�nSM:^�^��~M��Π1r�D6=��4Z��D�,�iHe���{S�U���
��t��L��&��My#���X�QU,�6T,r��ݎ�gɥ�}4���Le==�u���ц+�WѰ�EL��(��� �}�����~��[��n���C������'6�O��/��C�%J��9�������_
��j{ t�<����.��G��Ngw���I0�L'��OtE��b�R(���x�����"����b��ה��֯�̠��b7�q�Tҳ�	�h6+5�R"�?�߄���x2 SZa=�걼��xڔc�c~�=�p��3M��&5��0(�fS��F�#�-����i	���nS�8*����Xu��,�./f��bs8tY�(-��̰��*(j5)�bN�L��s��K�M�c���9~n�o�{?o�U?cުM�p=<{��s��7�z��Ջ��_�8Օ�8�2ކ>�u�^�2^��^��7�����r����ʣ�+��{MN�FCSY�H����\	s5�{��ՠk�E������K�<R:�9נg��[����߁oܿY����`�5g<�~z
| A����tg�`׏d�������l�5�}r�8����y<C�����3�e��i��Hu\�pǴ�g8R�A�������Z�M�#y�?��E�q@�����
=���\U���i�<�n��w���_a<����6��l`��6��l�g��Fei � 