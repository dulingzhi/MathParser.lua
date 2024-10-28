local c={}local t={}local o={}local function a(e)local n=t[e]if n then
return n
end
if o[e]then
error('critical dependency',2)end
o[e]=true
n=c[e]()o[e]=false
t[e]=n
return n
end
c['Helpers/Helpers']=(function(...)local r=string.char
local t=string.match
local l=string.gmatch
local c=table.insert
local a=string.utf8len or string.len
local i=string.utf8sub or string.sub
local n={}function n.stringToTable(o)local e={}for n=1,a(o)do
local n=i(o,n,n)c(e,n)end
return e
end
function n.createPatternLookupTable(o)local e={}for n=0,255 do
local n=r(n)if t(n,o)then
e[n]=true
end
end
return e
end
function n.makeTrie(e)local t={}for e,o in ipairs(e)do
local e=t
for n in l(o,".")do
e[n]=e[n]or{}e=e[n]end
e.value=o
end
return t
end
return n end)c['Evaluator/Evaluator']=(function(...)local e=a("Helpers/Helpers")local m=(unpack or table.unpack)local p=table.insert
local a={Unary={["-"]=function(e)return-e end,["!"]=function(e)return not e end,},Binary={["+"]=function(e,n,o)return(e(n))+(e(o))end,["-"]=function(e,n,o)return(e(n))-(e(o))end,["/"]=function(e,o,n)return(e(o))/(e(n))end,["*"]=function(e,o,n)return(e(o))*(e(n))end,["^"]=function(e,n,o)return(e(n))^(e(o))end,["%"]=function(e,o,n)return(e(o))%(e(n))end,["=="]=function(e,o,n)return(e(o))==(e(n))end,["!="]=function(e,o,n)return(e(o))~=(e(n))end,[">"]=function(e,n,o)return(e(n))>(e(o))end,["<"]=function(e,o,n)return(e(o))<(e(n))end,[">="]=function(e,o,n)return(e(o))>=(e(n))end,["<="]=function(e,o,n)return(e(o))<=(e(n))end,["||"]=function(e,o,n)return not not(e(o))or not not(e(n))end,["||||"]=function(e,n,o)return not not(e(n))or not not(e(o))end,["&&"]=function(e,o,n)return not not((e(o))and(e(n)))end,[":="]=function(e,t,n,o)o[(e(t))]=(e(n))end,}}local c={sin=math.sin,cos=math.cos,tan=math.tan,asin=math.asin,acos=math.acos,atan=math.atan,floor=math.floor,ceil=math.ceil,abs=math.abs,sqrt=math.sqrt,log=math.log,log10=math.log10,exp=math.exp,rad=math.rad,deg=math.deg}local function h(o,n,e,i)local t=o
local r=n or{}local l=e or a
local s=i or{}local d,n,u,i,o
local function f(e,...)for n=1,select('#',...)do
p(e,(select(n,...)))end
end
function d(e)local n=e.Value
local t=l.Unary[n]assert(t,"invalid operator: "..tostring(n))local n=o(e.Operand)return t(n,e)end
function n(e)local n=e.Value
local a=e.Left
local t=e.Right
local e=l.Binary[n]assert(e,"invalid operator")return e(o,a,t,r)end
function u(e)local o=not(not e.Operand)if o then
return d(e)end
return n(e)end
function i(n)local e=n.FunctionName
local t=n.Arguments
local n=s[e]or c[e]assert(n,"invalid function call: "..tostring(e))local e={}for t,n in ipairs(t)do
f(e,o(n))end
return n(m(e))end
function o(n)local e=n.TYPE
if e=="Constant"then
return tonumber(n.Value)elseif e=="Variable"then
local e=r[n.Value]if e==nil then
return tostring(n.Value)end
return e
elseif e=="Operator"or e=="UnaryOperator"then
return u(n)elseif e=="FunctionCall"then
return i(n)elseif e=="String"then
return tostring(n.Value)end
return error("Invalid node type: "..tostring(e).." ( You're not supposed to see this error message. )")end
local function i(o,i,e,n)t=o
r=i or{}l=e or a
s=n or c
end
local function e()assert(t,"No expression to evaluate")return o(t)end
return{resetToInitialState=i,evaluate=e}end
return h
end)c['Lexer/Lexer']=(function(...)local e=a("Helpers/Helpers")local n=a("Lexer/TokenFactory")local f=e.makeTrie
local m=e.stringToTable
local e=e.createPatternLookupTable
local c=table.concat
local r=table.insert
local E=string.rep
local v=string.reverse
local g=string.gsub
local P=n.createConstantToken
local k=n.createVariableToken
local V=n.createParenthesesToken
local S=n.createOperatorToken
local x=n.createCommaToken
local y=n.createStrToken
local h="+------------------------------+"local O="Expected a number after the 'x' or 'X'"local F="Expected a number after the decimal point"local L="Expected a number after the exponent sign"local n="Invalid character '%s'. Expected whitespace, parenthesis, comma, operator, or number."local A="No charStream given"local s={"+","-","*","/","^","%","==","!","!=",">","<",">=","<=","||","||||",'&&',":=",}local T=f(s)local N=e("%s")local a=e("%d")local U=e("[a-zA-Z_%.]")local b=e("[%da-fA-F]")local H=e("[+-]")local w=e("[eE]")local B=e("[xX]")local R=e("[a-zA-Z0-9_%.]")local C=e("[()]")local function Y(n,t,u)local d={}local i={}local o,l,e
if n then
n=n
o=m(n)l=o[u or 1]e=u or 1
d[n]=o
end
local n=(t and f(t))or T
local _=t or s
local u=n
local function n()return o[e+1]or"\0"end
local function t(n)local n=e+(n or 1)local o=o[n]or"\0"e=n
l=o
return o
end
local function p(n,t)local e=e+(t or 0)local e=E(" ",e-1).."^"local e="\n"..c(o).."\n"..e.."\n"..n
return e
end
local function E()local e=i
if#e>0 then
local e=c(e,"\n"..h)error("Lexer errors:".."\n"..h..e.."\n"..h)end
end
local function I(e)local e=(e or l)return a[e]or(e=="."and a[n()])end
local function Y(o)r(o,t())local e=b[n()]if not e then
local e=p(O,1)r(i,e)end
repeat
r(o,t())e=b[n()]until not e
return o
end
local function h(e)r(e,t())local o=a[n()]if not o then
local e=p(F,1)r(i,e)end
repeat
r(e,t())o=a[n()]until not o
return e
end
local function b(e)r(e,t())if H[n()]then
r(e,t())end
local o=a[n()]if not o then
local e=p(L,1)r(i,e)end
repeat
r(e,t())o=a[n()]until not o
return e
end
local function p()local e={l}local o=false
local o=false
local o=false
if l=='0'and B[n()]then
return tonumber(c(Y(e)),16)end
while a[n()]do
r(e,t())end
if n()=="."then
e=h(e)end
local n=n()if w[n]then
e=b(e)end
return tonumber(c(e))end
local function h()local l={l}local a=u
local o=o
local n=e
local e=1
while true do
local n=o[n+e]if not n or a[n]or n==")"or n==","then break end
e=e+1
r(l,n)end
if e>0 then
t(e-1)end
return c(l)end
local function a()local o,e={},0
local r
repeat
e=e+1
o[e]=l
local e=n()until not(R[e]and t())return c(o)end
local function c()if I(l)then
local n=p()return P(n,e)end
local n=v(g(v(h()),'^%s+',''))return y(n,e)end
local function h()local n=u
local r=o
local l=e
local e
local o=0
while true do
local t=r[l+o]n=n[t]if not n then break end
e=n.value
o=o+1
end
if not e then return end
t(#e-1)return e
end
local function r()local n=l
if N[n]then
return
elseif C[n]then
return V(n,e)elseif U[n]then
return k(a(),e)elseif n==","then
return x(e)else
local n=h()if n then
return S(n,e)end
return c()end
end
local function a()local o,e={},0
local n=l
while n~="\0"do
local r=r()if r then
e=e+1
o[e]=r
end
n=t()end
return o
end
local function r(n,t)if n then
n=n
o=d[n]or m(n)l=o[1]e=1
d[n]=o
end
u=(t and f(t))or T
_=t or s
end
local function e()assert(o,A)i={}local e=a()E()return e
end
return{resetToInitialState=r,run=e}end
return Y
end)c['Lexer/TokenFactory']=(function(...)local e={}function e.createConstantToken(e,n)return{TYPE="Constant",Value=e,Position=n}end
function e.createVariableToken(e,n)return{TYPE="Variable",Value=e,Position=n}end
function e.createParenthesesToken(n,e)return{TYPE="Parentheses",Value=n,Position=e}end
function e.createOperatorToken(n,e)return{TYPE="Operator",Value=n,Position=e}end
function e.createCommaToken(e)return{TYPE="Comma",Value=",",Position=e}end
function e.createStrToken(n,e)return{TYPE="String",Value=n,Position=e}end
return e end)c['Parser/Parser']=(function(...)local n=a("Helpers/Helpers")local e=a("Parser/NodeFactory")local Y=n.stringToTable
local h=table.insert
local n=table.concat
local T=math.max
local m=math.min
local s=string.rep
local O=e.createUnaryOperatorNode
local S=e.createOperatorNode
local F=e.createFunctionCallNode
local a=20
local L="No tokens given"local _="No tokens to parse"local x="Expected EOF, got '%s'"local y="Unexpected token: '%s' in <primary>, expected constant, variable or function call"local u="Expected expression, got EOF"local b="Expected ')', got EOF"local k="Expected ',' or ')', got '%s'"local d="<No charStream, error message: %s>"local f={Unary={["-"]=7,["!"]=7,},Binary={[":="]=1,["&&"]=2,["||"]=3,["||||"]=3,["=="]=4,["!="]=4,[">"]=4,["<"]=4,[">="]=4,["<="]=4,["+"]=5,["-"]=5,["*"]=6,["/"]=6,["%"]=6,["^"]=7,},RightAssociativeBinaryOperators={["^"]=true},}local e={}local function E(l,t,n,o,c)local r,e
if l then
r=n or 1
e=l[r]end
local t=t or f
local i=o
local c=c
local function p(e)return l[r+(e or 1)]end
local function n(n)local o=r+(n or 1)local n=l[o]r=o
e=n
return n
end
local function E(n)local e=n or e
if not t.Binary then return end
return e and e.TYPE=="Operator"and t.Binary[e.Value]end
local function g(n)local e=n or e
if not t.Unary then return end
return e and e.TYPE=="Operator"and t.Unary[e.Value]end
local function P(n)local e=n or e
if not t.RightAssociativeBinaryOperators then return end
return e and e.TYPE=="Operator"and t.RightAssociativeBinaryOperators[e.Value]end
local function v()local n=p()if not n then
if c[e.Value]~=nil then
return true,true
end
end
if e.TYPE=="Variable"and n.TYPE=="Parentheses"and n.Value=="("then
return true
end
if c[e.Value]~=nil then
return true,true
end
end
local function V(e)return e and t.Binary[e.Value]end
local function o(o,...)if not i then
return d:format(o)end
local n=Y(i)local t=o:format(...)local e=(not e and#n+1)or e.Position
local o={}for e=T(1,e-a),m(e+a,#n)do
h(o,n[e])end
local n=table.concat(o)local e=s(" ",e-1).."^"return"\n"..n.."\n"..e.."\n"..t
end
local m,s,d,T,a
function m(r)local l=e.Value
n(2)local t={}while not r do
local r=a()h(t,r)if not e then
local e=p(-1)if e and e.TYPE=="Comma"then
error(o(u))end
error(o(b))break
elseif e.Value==")"then
break
elseif e.TYPE=="Comma"then
n()else
error(o(k,e.Value))end
end
if not r then
n()else
n(-1)end
return F(l,t)end
function s(l)local t=d()while E(e)do
local r=V(e)if r<=l and not P(e)then
break
end
local e=e
if not n()then
error(o(u))end
local n=s(r)t=S(e.Value,t,n)end
return t
end
function d()if not g(e)then
return T()end
local e=e.Value
if not n()then
error(o(u))end
local n=d()return O(e,n)end
function T()local t=e
if not t then return end
local l=t.Value
local r=t.TYPE
if r=="Parentheses"and l=="("then
n()local t=a()if not e or e.Value~=")"then
error(o(b))end
n()return t
elseif r=="Variable"then
local e,o=v()if e then
return m(o)end
n()return t
elseif r=="Constant"or r=="String"then
n()return t
end
error(o(y,l))end
function a()local e=s(0)return e
end
local function u(n,o,a,d,u)assert(n,L)l=n
r=a or 1
e=n[r]t=o or f
i=d
c=u
end
local function r(n)assert(l,_)local t=a()if e and not n then
error(o(x,e.Value))end
return t
end
return{resetToInitialState=u,parse=r}end
return E
end)c['Parser/NodeFactory']=(function(...)local e={}function e.createUnaryOperatorNode(n,e)return{TYPE="UnaryOperator",Value=n,Operand=e}end
function e.createOperatorNode(o,e,n)return{TYPE="Operator",Value=o,Left=e,Right=n}end
function e.createFunctionCallNode(n,e)return{TYPE="FunctionCall",FunctionName=n,Arguments=e}end
return e end)c['MathParser']=(function(...)local e=a("Helpers/Helpers")local c=a("Evaluator/Evaluator")local i=a("Lexer/Lexer")local u=a("Parser/Parser")local e={}function e:tokenize(e)if self.cachedTokens[e]then
return self.cachedTokens[e]end
self.Lexer.resetToInitialState(e,self.operators)local n=self.Lexer.run()self.cachedTokens[e]=n
return n
end
function e:parse(n,e)if self.cachedASTs[e]then
return self.cachedASTs[e]end
self.Parser.resetToInitialState(n,self.operatorPrecedenceLevels,nil,e,self.functions)local n=self.Parser.parse()self.cachedASTs[e]=n
return n
end
function e:evaluate(e,n)if n and self.cachedResults[e]~=nil then
return self.cachedResults[e]end
self.Evaluator.resetToInitialState(e,self.variables,self.operatorFunctions,self.functions)local o=self.Evaluator:evaluate()if n then
self.cachedResults[e]=o
end
return o
end
function e:solve(e)return self:evaluate(self:parse(self:tokenize(e),e))end
function e:addVariable(e,n)self.variables=self.variables or{}self.variables[e]=n
self.cachedResults={}end
function e:addVariables(e)for n,e in pairs(e)do
self:addVariable(n,e)end
self.cachedResults={}end
function e:addFunction(e,n)self.functions=self.functions or{}self.functions[e]=n
self.cachedResults={}end
function e:removeFunction(e)if self.functions and self.functions[e]then
self.functions[e]=nil
self.cachedResults={}end
end
function e:addFunctions(e)for n,e in pairs(e)do
self:addFunction(n,e)end
self.cachedResults={}end
function e:setOperatorPrecedenceLevels(e)self.operatorPrecedenceLevels=e
self.cachedASTs={}end
function e:setVariables(e)self.variables=e
self.cachedResults={}end
function e:setOperatorFunctions(e)self.operatorFunctions=e
self.cachedResults={}end
function e:setOperators(e)self.operators=e
self.cachedTokens={}end
function e:setFunctions(e)self.functions=e
self.cachedResults={}end
function e:resetCaches()self.cachedTokens={}self.cachedASTs={}self.cachedResults={}end
function e:resetToInitialState(t,r,n,e,o)self.operatorPrecedenceLevels=t
self.variables=r
self.operatorFunctions=n
self.operators=e
self.functions=o
self.cachedTokens={}self.cachedASTs={}self.cachedResults={}end
local t={}function t:new(t,o,r,l,a)local n={}for e,t in pairs(e)do
n[e]=t
end
o=o or{}o['false']=false
o['true']=true
n.operatorPrecedenceLevels=t
n.variables=o
n.operatorFunctions=r
n.operators=l
n.functions=a
n.cachedTokens={}n.cachedASTs={}n.cachedResults={}n.Lexer=i(nil,l)n.Parser=u(nil,t)n.Evaluator=c(nil,o,r,a)return n
end
return t
end)local n,e="LibFormula-1.0",1
local n,e=LibStub and LibStub:NewLibrary(n,e)or{}if not n then return end
local e={}function n:CreateInstance()return e:new()end
local o=a('MathParser')function e:new()local e=setmetatable({__vm=o:new()},{__index=self})assert(e.__vm,'Invalid instance object')return e
end
function e:addFunc(e,n)self.__vm:addFunction(e,n)end
function e:removeFunc(e)self.__vm:removeFunction(e)end
function e:exec(e)return self.__vm:evaluate(e)end
function e:parse(e)return self.__vm:parse(self.__vm:tokenize(e),e)end
function e:perform(e)return self.__vm:solve(e)end
return n
