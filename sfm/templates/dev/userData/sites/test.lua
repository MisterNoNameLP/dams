return [[<!DOCTYPE html>

<h3>test</h3>

<form action="http://localhost:8023/test" method="POST">
    <div>
      <input type="hidden" name="action" value="dumpRequest">
    </div>
    <div>
      <textarea for="test" id="test" name="test">test = text</textarea>
    </div>
    <div>
      <label for="say">What greeting do you want to say?</label>
      <input name="say" id="say" value="Hi?">
    </div>
    <div>
      <label for="to">Who do you want to say it to?</label>
      <input name="to" id="to" value="Mom">
    </div>
    <div>
      <button>Send my greetings</button>
    </div>
  </form>
  


]]