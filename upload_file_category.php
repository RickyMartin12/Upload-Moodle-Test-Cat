<?php

    $path="https://upload-moodle-test-cat-production.up.railway.app/cat/";//server path
    foreach ($_FILES as $key) {
        if($key['error'] == UPLOAD_ERR_OK ){
            $name = $key['name'];
            $temp = $key['tmp_name'];
            $size= ($key['size'] / 1000)."Kb";
            move_uploaded_file($temp, $path . $name);
            echo "
                <div>
                    <h12><strong>File Name: $name</strong></h2><br />
                    <h12><strong>Size: $size</strong></h2><br />
                    <hr>
                </div>
                ";
        }else{
            echo $key['error'];
        }
    } 

?>