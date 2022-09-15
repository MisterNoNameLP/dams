body:addHead([[<style>
    .block {
        display: block;
    }

    .inline-block {
        display: inline-block;
    }

    .max-width {
        box-sizing: border-box;
        width: 100%
    }

    div.token-editor-mainpage {
        text-align: center;
    }

    div.token-editor {
        display: inline-block;
        text-align: center;
    }

    

</style>]])

body:addRaw([[
    <div class="token-editor-mainpage">
        <div class="token-editor">
            <h1>Add token</h1>
            <form action="" method="POST">
                <input type="hidden" name="action" value="dumpRequest">

                <input type="text" class="block max-width" name="name" placeholder="Name">
                <textarea name="description" class="block max-width" placeholder="Description"></textarea>  
                <div>
                    <label>Expire in:</label>
                    <input type="number" name="expireTimeValue">
                    <select name="expireTimeUnit">
                        <option value="minutes">Minutes</option>
                        <option value="days">Days</option>
                        <option value="weeks">Weeks</option>
                        <option value="months">Months</option>
                        <option value="years">Years</option>
                        <option value="never">Never</option>
                    </select>
                </div>
                

                <input type="submit" value="Add token">
            </form>
        </div>
    </div>

]])

return body:generateCode()