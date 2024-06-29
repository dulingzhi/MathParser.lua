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
local e=string.utf8len or string.len
local a=string.utf8sub or string.sub
local n={}function n.stringToTable(o)local n={}for e=1,e(o)do
local e=a(o,e,e)c(n,e)end
return n
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
return n end)c['Evaluator/Evaluator']=(function(...)local e=a("Helpers/Helpers")local p=(unpack or table.unpack)local m=table.insert
local c={Unary={["-"]=function(e)return-e end,["!"]=function(e)return not e end,},Binary={["+"]=function(n,e)return n+e end,["-"]=function(n,e)return n-e end,["/"]=function(n,e)return n/e end,["*"]=function(e,n)return e*n end,["^"]=function(e,n)return e^n end,["%"]=function(n,e)return n%e end,["=="]=function(n,e)return n==e end,["!="]=function(e,n)return e~=n end,[">"]=function(e,n)return e>n end,["<"]=function(e,n)return e<n end,[">="]=function(e,n)return e>=n end,["<="]=function(e,n)return e<=n end,["||"]=function(n,e)return not not n or not not e end,["||||"]=function(e,n)return not not e or not not n end,["&&"]=function(n,e)return not not(n and e)end,[":="]=function(n,e,t,o)o[n]=e end,}}local a={sin=math.sin,cos=math.cos,tan=math.tan,asin=math.asin,acos=math.acos,atan=math.atan,floor=math.floor,ceil=math.ceil,abs=math.abs,sqrt=math.sqrt,log=math.log,log10=math.log10,exp=math.exp,rad=math.rad,deg=math.deg}local function h(e,n,o,i)local r=e
local l=n or{}local t=o or c
local f=i or{}local u,d,s,i,o
function u(e)local n=e.Value
local t=t.Unary[n]assert(t,"invalid operator: "..tostring(n))local n=o(e.Operand)return t(n,e)end
function d(e)local n=e.Value
local r=e.Left
local a=e.Right
local n=t.Binary[n]assert(n,"invalid operator")local t=o(r)local o=o(a)return n(t,o,e,l)end
function s(e)local n=not(not e.Operand)if n then
return u(e)end
return d(e)end
function i(n)local e=n.FunctionName
local t=n.Arguments
local n=f[e]or a[e]assert(n,"invalid function call: "..tostring(e))local e={}for t,n in ipairs(t)do
local n=o(n)m(e,n)end
return n(p(e))end
function o(n)local e=n.TYPE
if e=="Constant"then
return tonumber(n.Value)elseif e=="Variable"then
local e=l[n.Value]if e==nil then
return tostring(n.Value)end
return e
elseif e=="Operator"or e=="UnaryOperator"then
return s(n)elseif e=="FunctionCall"then
return i(n)elseif e=="String"then
return tostring(n.Value)end
return error("Invalid node type: "..tostring(e).." ( You're not supposed to see this error message. )")end
local function u(i,n,o,e)r=i
l=n or{}t=o or c
f=e or a
end
local function e()assert(r,"No expression to evaluate")return o(r)end
return{resetToInitialState=u,evaluate=e}end
return h end)c['Lexer/Lexer']=(function(...)local e=a("Helpers/Helpers")local n=a("Lexer/TokenFactory")local f=e.makeTrie
local P=e.stringToTable
local e=e.createPatternLookupTable
local c=table.concat
local l=table.insert
local Y=string.rep
local b=string.reverse
local S=string.gsub
local F=n.createConstantToken
local L=n.createVariableToken
local k=n.createParenthesesToken
local v=n.createOperatorToken
local g=n.createCommaToken
local E=n.createStrToken
local s="+------------------------------+"local x="Expected a number after the 'x' or 'X'"local V="Expected a number after the decimal point"local y="Expected a number after the exponent sign"local n="Invalid character '%s'. Expected whitespace, parenthesis, comma, operator, or number."local O="No charStream given"local d={"+","-","*","/","^","%","==","!","!=",">","<",">=","<=","||","||||",'&&',":=",}local m=f(d)local R=e("%s")local a=e("%d")local _=e("[a-zA-Z_%.]")local T=e("[%da-fA-F]")local U=e("[+-]")local C=e("[eE]")local w=e("[xX]")local B=e("[a-zA-Z0-9_%.]")local H=e("[()]")local function A(n,t,u)local h={}local i={}local o,r,e
if n then
n=n
o=P(n)r=o[u or 1]e=u or 1
h[n]=o
end
local n=(t and f(t))or m
local N=t or d
local u=n
local function n()return o[e+1]or"\0"end
local function t(n)local t=e+(n or 1)local n=o[t]or"\0"e=t
r=n
return n
end
local function p(n,t)local e=e+(t or 0)local e=Y(" ",e-1).."^"local e="\n"..c(o).."\n"..e.."\n"..n
return e
end
local function A()local e=i
if#e>0 then
local e=c(e,"\n"..s)error("Lexer errors:".."\n"..s..e.."\n"..s)end
end
local function I(e)local e=(e or r)return a[e]or(e=="."and a[n()])end
local function Y(e)l(e,t())local o=T[n()]if not o then
local e=p(x,1)l(i,e)end
repeat
l(e,t())o=T[n()]until not o
return e
end
local function T(o)l(o,t())local e=a[n()]if not e then
local e=p(V,1)l(i,e)end
repeat
l(o,t())e=a[n()]until not e
return o
end
local function s(e)l(e,t())if U[n()]then
l(e,t())end
local o=a[n()]if not o then
local e=p(y,1)l(i,e)end
repeat
l(e,t())o=a[n()]until not o
return e
end
local function p()local e={r}local o=false
local o=false
local o=false
if r=='0'and w[n()]then
return tonumber(c(Y(e)),16)end
while a[n()]do
l(e,t())end
if n()=="."then
e=T(e)end
local n=n()if C[n]then
e=s(e)end
return tonumber(c(e))end
local function a()local r={r}local a=u
local o=o
local n=e
local e=1
while true do
local n=o[n+e]if not n or a[n]or n==")"or n==","then break end
e=e+1
l(r,n)end
if e>0 then
t(e-1)end
return c(r)end
local function s()local o,e={},0
local l
repeat
e=e+1
o[e]=r
local e=n()until not(B[e]and t())return c(o)end
local function c()if I(r)then
local n=p()return F(n,e)end
local n=b(S(b(a()),'^%s+',''))return E(n,e)end
local function a()local n=u
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
local function l()local n=r
if R[n]then
return
elseif H[n]then
return k(n,e)elseif _[n]then
return L(s(),e)elseif n==","then
return g(e)else
local n=a()if n then
return v(n,e)end
return c()end
end
local function a()local o,e={},0
local n=r
while n~="\0"do
local l=l()if l then
e=e+1
o[e]=l
end
n=t()end
return o
end
local function l(n,t)if n then
n=n
o=h[n]or P(n)r=o[1]e=1
h[n]=o
end
u=(t and f(t))or m
N=t or d
end
local function n()assert(o,O)i={}local e=a()A()return e
end
return{resetToInitialState=l,run=n}end
return A
end)c['Lexer/TokenFactory']=(function(...)local e={}function e.createConstantToken(n,e)return{TYPE="Constant",Value=n,Position=e}end
function e.createVariableToken(e,n)return{TYPE="Variable",Value=e,Position=n}end
function e.createParenthesesToken(e,n)return{TYPE="Parentheses",Value=e,Position=n}end
function e.createOperatorToken(n,e)return{TYPE="Operator",Value=n,Position=e}end
function e.createCommaToken(e)return{TYPE="Comma",Value=",",Position=e}end
function e.createStrToken(e,n)return{TYPE="String",Value=e,Position=n}end
return e end)c['Parser/Parser']=(function(...)local n=a("Helpers/Helpers")local e=a("Parser/NodeFactory")local _=n.stringToTable
local b=table.insert
local n=table.concat
local A=math.max
local N=math.min
local T=string.rep
local R=e.createUnaryOperatorNode
local Y=e.createOperatorNode
local O=e.createFunctionCallNode
local a=20
local y="No tokens given"local x="No tokens to parse"local L="Expected EOF, got '%s'"local F="Unexpected token: '%s' in <primary>, expected constant, variable or function call"local d="Expected expression, got EOF"local p="Expected ')', got EOF"local S="Expected ',' or ')', got '%s'"local m="<No charStream, error message: %s>"local h={Unary={["-"]=7,["!"]=7,},Binary={[":="]=1,["&&"]=2,["||"]=3,["||||"]=3,["=="]=4,["!="]=4,[">"]=4,["<"]=4,[">="]=4,["<="]=4,["+"]=5,["-"]=5,["*"]=6,["/"]=6,["%"]=6,["^"]=7,},RightAssociativeBinaryOperators={["^"]=true},}local e={}local function V(r,n,o,c,i)local l,e
if r then
l=o or 1
e=r[l]end
local t=n or h
local s=c
local u=i
local function f(e)return r[l+(e or 1)]end
local function n(n)local o=l+(n or 1)local n=r[o]l=o
e=n
return n
end
local function g(n)local e=n or e
if not t.Binary then return end
return e and e.TYPE=="Operator"and t.Binary[e.Value]end
local function E(n)local e=n or e
if not t.Unary then return end
return e and e.TYPE=="Operator"and t.Unary[e.Value]end
local function k(n)local e=n or e
if not t.RightAssociativeBinaryOperators then return end
return e and e.TYPE=="Operator"and t.RightAssociativeBinaryOperators[e.Value]end
local function v()local n=f()if not n then
if u[e.Value]~=nil then
return true,true
end
end
if e.TYPE=="Variable"and n.TYPE=="Parentheses"and n.Value=="("then
return true
end
if u[e.Value]~=nil then
return true,true
end
end
local function P(e)return e and t.Binary[e.Value]end
local function o(o,...)if not s then
return m:format(o)end
local n=_(s)local t=o:format(...)local e=(not e and#n+1)or e.Position
local o={}for e=A(1,e-a),N(e+a,#n)do
b(o,n[e])end
local n=table.concat(o)local e=T(" ",e-1).."^"return"\n"..n.."\n"..e.."\n"..t
end
local m,i,c,T,a
function m(l)local r=e.Value
n(2)local t={}while not l do
local l=a()b(t,l)if not e then
local e=f(-1)if e and e.TYPE=="Comma"then
error(o(d))end
error(o(p))break
elseif e.Value==")"then
break
elseif e.TYPE=="Comma"then
n()else
error(o(S,e.Value))end
end
if not l then
n()else
n(-1)end
return O(r,t)end
function i(r)local t=c()while g(e)do
local l=P(e)if l<=r and not k(e)then
break
end
local e=e
if not n()then
error(o(d))end
local n=i(l)t=Y(e.Value,t,n)end
return t
end
function c()if not E(e)then
return T()end
local e=e.Value
if not n()then
error(o(d))end
local n=c()return R(e,n)end
function T()local t=e
if not t then return end
local r=t.Value
local l=t.TYPE
if l=="Parentheses"and r=="("then
n()local t=a()if not e or e.Value~=")"then
error(o(p))end
n()return t
elseif l=="Variable"then
local o,e=v()if o then
return m(e)end
n()return t
elseif l=="Constant"or l=="String"then
n()return t
end
error(o(F,r))end
function a()local e=i(0)return e
end
local function d(n,c,a,o,i)assert(n,y)r=n
l=a or 1
e=n[l]t=c or h
s=o
u=i
end
local function t(n)assert(r,x)local t=a()if e and not n then
error(o(L,e.Value))end
return t
end
return{resetToInitialState=d,parse=t}end
return V
end)c['Parser/NodeFactory']=(function(...)local e={}function e.createUnaryOperatorNode(n,e)return{TYPE="UnaryOperator",Value=n,Operand=e}end
function e.createOperatorNode(e,n,o)return{TYPE="Operator",Value=e,Left=n,Right=o}end
function e.createFunctionCallNode(n,e)return{TYPE="FunctionCall",FunctionName=n,Arguments=e}end
return e end)c['MathParser']=(function(...)local e=a("Helpers/Helpers")local u=a("Evaluator/Evaluator")local i=a("Lexer/Lexer")local c=a("Parser/Parser")local e={}function e:tokenize(e)if self.cachedTokens[e]then
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
function e:addFunction(n,e)self.functions=self.functions or{}self.functions[n]=e
self.cachedResults={}end
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
function e:resetToInitialState(e,n,t,o,l)self.operatorPrecedenceLevels=e
self.variables=n
self.operatorFunctions=t
self.operators=o
self.functions=l
self.cachedTokens={}self.cachedASTs={}self.cachedResults={}end
local a={}function a:new(a,o,t,l,r)local n={}for t,e in pairs(e)do
n[t]=e
end
o=o or{}o['false']=false
o['true']=true
n.operatorPrecedenceLevels=a
n.variables=o
n.operatorFunctions=t
n.operators=l
n.functions=r
n.cachedTokens={}n.cachedASTs={}n.cachedResults={}n.Lexer=i(nil,l)n.Parser=c(nil,a)n.Evaluator=u(nil,o,t,r)return n
end
return a
end)local e,n="LibFormula-1.0",1
local n,e=LibStub and LibStub:NewLibrary(e,n)or{}if not n then return end
local e={}function n:CreateInstance()return e:new()end
local o=a('MathParser')function e:new()local e=setmetatable({__vm=o:new()},{__index=self})assert(e.__vm,'Invalid instance object')return e
end
function e:addFunc(e,n)self.__vm:addFunction(e,n)end
function e:exec(e)return self.__vm:evaluate(e)end
function e:parse(e)return self.__vm:parse(self.__vm:tokenize(e),e)end
function e:perform(e)return self.__vm:solve(e)end
return n
