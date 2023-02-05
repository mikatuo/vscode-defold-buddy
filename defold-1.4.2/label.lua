---@meta

---Label API documentation
---@class label
label = {}

---Docs: https://defold.com/ref/stable/label/?q=label.set_text#label.set_text
---
---Sets the text of a label component
---This method uses the message passing that means the value will be set after <code>dispatch messages</code> step.
---More information is available in the Application Lifecycle manual.
---@param url string|hash|url the label that should have a constant set
---@param text string the text
function label.set_text(url, text) end

---Docs: https://defold.com/ref/stable/label/?q=label.get_text#label.get_text
---
---Gets the text from a label component
---@param url string|hash|url the label to get the text from
---@return string metrics the label text
function label.get_text(url) end

