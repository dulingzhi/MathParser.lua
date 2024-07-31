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
c['Helpers/Helpers']=(function(...)local l=string.char
local t=string.match
local r=string.gmatch
local a=table.insert
local o=string.utf8len or string.len
local c=string.utf8sub or string.sub
local n={}function n.stringToTable(e)local n={}for o=1,o(e)do
local e=c(e,o,o)a(n,e)end
return n
end
function n.createPatternLookupTable(o)local e={}for n=0,255 do
local n=l(n)if t(n,o)then
e[n]=true
end
end
return e
end
function n.makeTrie(e)local o={}for e,t in ipairs(e)do
local e=o
for n in r(t,".")do
e[n]=e[n]or{}e=e[n]end
e.value=t
end
return o
end
return n end)c['Evaluator/Evaluator']=(function(...)local e=a("Helpers/Helpers")local p=(unpack or table.unpack)local h=table.insert
local a={Unary={["-"]=function(e)return-e end,["!"]=function(e)return not e end,},Binary={["+"]=function(e,n)return e+n end,["-"]=function(e,n)return e-n end,["/"]=function(n,e)return n/e end,["*"]=function(n,e)return n*e end,["^"]=function(e,n)return e^n end,["%"]=function(n,e)return n%e end,["=="]=function(n,e)return n==e end,["!="]=function(n,e)return n~=e end,[">"]=function(e,n)return e>n end,["<"]=function(n,e)return n<e end,[">="]=function(n,e)return n>=e end,["<="]=function(n,e)return n<=e end,["||"]=function(n,e)return not not n or not not e end,["||||"]=function(e,n)return not not e or not not n end,["&&"]=function(n,e)return not not(n and e)end,[":="]=function(o,e,t,n)n[o]=e end,}}local u={sin=math.sin,cos=math.cos,tan=math.tan,asin=math.asin,acos=math.acos,atan=math.atan,floor=math.floor,ceil=math.ceil,abs=math.abs,sqrt=math.sqrt,log=math.log,log10=math.log10,exp=math.exp,rad=math.rad,deg=math.deg}local function f(o,n,e,c)local l=o
local t=n or{}local r=e or a
local c=c or{}local s,n,i,d,o
function s(e)local t=e.Value
local n=r.Unary[t]assert(n,"invalid operator: "..tostring(t))local o=o(e.Operand)return n(o,e)end
function n(e)local n=e.Value
local l=e.Left
local a=e.Right
local n=r.Binary[n]assert(n,"invalid operator")local l=o(l)local o=o(a)return n(l,o,e,t)end
function i(e)local o=not(not e.Operand)if o then
return s(e)end
return n(e)end
function d(n)local e=n.FunctionName
local t=n.Arguments
local n=c[e]or u[e]assert(n,"invalid function call: "..tostring(e))local e={}for t,n in ipairs(t)do
local n=o(n)h(e,n)end
return n(p(e))end
function o(e)local n=e.TYPE
if n=="Constant"then
return tonumber(e.Value)elseif n=="Variable"then
local n=t[e.Value]if n==nil then
return tostring(e.Value)end
return n
elseif n=="Operator"or n=="UnaryOperator"then
return i(e)elseif n=="FunctionCall"then
return d(e)elseif n=="String"then
return tostring(e.Value)end
return error("Invalid node type: "..tostring(n).." ( You're not supposed to see this error message. )")end
local function i(o,i,e,n)l=o
t=i or{}r=e or a
c=n or u
end
local function e()assert(l,"No expression to evaluate")return o(l)end
return{resetToInitialState=i,evaluate=e}end
return f end)c['Lexer/Lexer']=(function(...)local e=a("Helpers/Helpers")local n=a("Lexer/TokenFactory")local u=e.makeTrie
local b=e.stringToTable
local e=e.createPatternLookupTable
local c=table.concat
local o=table.insert
local E=string.rep
local T=string.reverse
local g=string.gsub
local P=n.createConstantToken
local k=n.createVariableToken
local S=n.createParenthesesToken
local V=n.createOperatorToken
local x=n.createCommaToken
local y=n.createStrToken
local h="+------------------------------+"local O="Expected a number after the 'x' or 'X'"local F="Expected a number after the decimal point"local L="Expected a number after the exponent sign"local n="Invalid character '%s'. Expected whitespace, parenthesis, comma, operator, or number."local C="No charStream given"local p={"+","-","*","/","^","%","==","!","!=",">","<",">=","<=","||","||||",'&&',":=",}local v=u(p)local A=e("%s")local a=e("%d")local w=e("[a-zA-Z_%.]")local m=e("[%da-fA-F]")local B=e("[+-]")local H=e("[eE]")local N=e("[xX]")local U=e("[a-zA-Z0-9_%.]")local R=e("[()]")local function Y(n,t,d)local s={}local i={}local l,r,e
if n then
n=n
l=b(n)r=l[d or 1]e=d or 1
s[n]=l
end
local n=(t and u(t))or v
local _=t or p
local f=n
local function n()return l[e+1]or"\0"end
local function t(n)local n=e+(n or 1)local o=l[n]or"\0"e=n
r=o
return o
end
local function d(n,o)local e=e+(o or 0)local e=E(" ",e-1).."^"local e="\n"..c(l).."\n"..e.."\n"..n
return e
end
local function E()local e=i
if#e>0 then
local e=c(e,"\n"..h)error("Lexer errors:".."\n"..h..e.."\n"..h)end
end
local function I(e)local e=(e or r)return a[e]or(e=="."and a[n()])end
local function Y(e)o(e,t())local l=m[n()]if not l then
local e=d(O,1)o(i,e)end
repeat
o(e,t())l=m[n()]until not l
return e
end
local function h(l)o(l,t())local e=a[n()]if not e then
local e=d(F,1)o(i,e)end
repeat
o(l,t())e=a[n()]until not e
return l
end
local function O(e)o(e,t())if B[n()]then
o(e,t())end
local l=a[n()]if not l then
local e=d(L,1)o(i,e)end
repeat
o(e,t())l=a[n()]until not l
return e
end
local function m()local e={r}local l=false
local l=false
local l=false
if r=='0'and N[n()]then
return tonumber(c(Y(e)),16)end
while a[n()]do
o(e,t())end
if n()=="."then
e=h(e)end
local n=n()if H[n]then
e=O(e)end
return tonumber(c(e))end
local function a()local r={r}local a=f
local l=l
local e=e
local n=1
while true do
local e=l[e+n]if not e or a[e]or e==")"or e==","then break end
n=n+1
o(r,e)end
if n>0 then
t(n-1)end
return c(r)end
local function d()local o,e={},0
local l
repeat
e=e+1
o[e]=r
local e=n()until not(U[e]and t())return c(o)end
local function h()if I(r)then
local n=m()return P(n,e)end
local n=T(g(T(a()),'^%s+',''))return y(n,e)end
local function a()local n=f
local r=l
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
local function c()local n=r
if A[n]then
return
elseif R[n]then
return S(n,e)elseif w[n]then
return k(d(),e)elseif n==","then
return x(e)else
local n=a()if n then
return V(n,e)end
return h()end
end
local function a()local n,e={},0
local o=r
while o~="\0"do
local l=c()if l then
e=e+1
n[e]=l
end
o=t()end
return n
end
local function t(n,o)if n then
n=n
l=s[n]or b(n)r=l[1]e=1
s[n]=l
end
f=(o and u(o))or v
_=o or p
end
local function n()assert(l,C)i={}local e=a()E()return e
end
return{resetToInitialState=t,run=n}end
return Y
end)c['Lexer/TokenFactory']=(function(...)local e={}function e.createConstantToken(e,n)return{TYPE="Constant",Value=e,Position=n}end
function e.createVariableToken(e,n)return{TYPE="Variable",Value=e,Position=n}end
function e.createParenthesesToken(e,n)return{TYPE="Parentheses",Value=e,Position=n}end
function e.createOperatorToken(e,n)return{TYPE="Operator",Value=e,Position=n}end
function e.createCommaToken(e)return{TYPE="Comma",Value=",",Position=e}end
function e.createStrToken(e,n)return{TYPE="String",Value=e,Position=n}end
return e end)c['Parser/Parser']=(function(...)local n=a("Helpers/Helpers")local e=a("Parser/NodeFactory")local Y=n.stringToTable
local m=table.insert
local n=table.concat
local h=math.max
local f=math.min
local d=string.rep
local O=e.createUnaryOperatorNode
local S=e.createOperatorNode
local F=e.createFunctionCallNode
local a=20
local L="No tokens given"local _="No tokens to parse"local x="Expected EOF, got '%s'"local y="Unexpected token: '%s' in <primary>, expected constant, variable or function call"local s="Expected expression, got EOF"local b="Expected ')', got EOF"local P="Expected ',' or ')', got '%s'"local u="<No charStream, error message: %s>"local p={Unary={["-"]=7,["!"]=7,},Binary={[":="]=1,["&&"]=2,["||"]=3,["||||"]=3,["=="]=4,["!="]=4,[">"]=4,["<"]=4,[">="]=4,["<="]=4,["+"]=5,["-"]=5,["*"]=6,["/"]=6,["%"]=6,["^"]=7,},RightAssociativeBinaryOperators={["^"]=true},}local e={}local function g(r,t,c,n,o)local l,e
if r then
l=c or 1
e=r[l]end
local t=t or p
local c=n
local i=o
local function T(e)return r[l+(e or 1)]end
local function n(n)local o=l+(n or 1)local n=r[o]l=o
e=n
return n
end
local function k(n)local e=n or e
if not t.Binary then return end
return e and e.TYPE=="Operator"and t.Binary[e.Value]end
local function E(n)local e=n or e
if not t.Unary then return end
return e and e.TYPE=="Operator"and t.Unary[e.Value]end
local function V(n)local e=n or e
if not t.RightAssociativeBinaryOperators then return end
return e and e.TYPE=="Operator"and t.RightAssociativeBinaryOperators[e.Value]end
local function g()local n=T()if not n then
if i[e.Value]~=nil then
return true,true
end
end
if e.TYPE=="Variable"and n.TYPE=="Parentheses"and n.Value=="("then
return true
end
if i[e.Value]~=nil then
return true,true
end
end
local function v(e)return e and t.Binary[e.Value]end
local function o(o,...)if not c then
return u:format(o)end
local n=Y(c)local t=o:format(...)local e=(not e and#n+1)or e.Position
local o={}for e=h(1,e-a),f(e+a,#n)do
m(o,n[e])end
local n=table.concat(o)local e=d(" ",e-1).."^"return"\n"..n.."\n"..e.."\n"..t
end
local h,d,u,f,a
function h(t)local r=e.Value
n(2)local l={}while not t do
local t=a()m(l,t)if not e then
local e=T(-1)if e and e.TYPE=="Comma"then
error(o(s))end
error(o(b))break
elseif e.Value==")"then
break
elseif e.TYPE=="Comma"then
n()else
error(o(P,e.Value))end
end
if not t then
n()else
n(-1)end
return F(r,l)end
function d(r)local t=u()while k(e)do
local l=v(e)if l<=r and not V(e)then
break
end
local r=e
if not n()then
error(o(s))end
local e=d(l)t=S(r.Value,t,e)end
return t
end
function u()if not E(e)then
return f()end
local e=e.Value
if not n()then
error(o(s))end
local n=u()return O(e,n)end
function f()local t=e
if not t then return end
local r=t.Value
local l=t.TYPE
if l=="Parentheses"and r=="("then
n()local t=a()if not e or e.Value~=")"then
error(o(b))end
n()return t
elseif l=="Variable"then
local o,e=g()if o then
return h(e)end
n()return t
elseif l=="Constant"or l=="String"then
n()return t
end
error(o(y,r))end
function a()local e=d(0)return e
end
local function s(n,u,d,o,a)assert(n,L)r=n
l=d or 1
e=n[l]t=u or p
c=o
i=a
end
local function t(n)assert(r,_)local t=a()if e and not n then
error(o(x,e.Value))end
return t
end
return{resetToInitialState=s,parse=t}end
return g
end)c['Parser/NodeFactory']=(function(...)local e={}function e.createUnaryOperatorNode(n,e)return{TYPE="UnaryOperator",Value=n,Operand=e}end
function e.createOperatorNode(o,e,n)return{TYPE="Operator",Value=o,Left=e,Right=n}end
function e.createFunctionCallNode(e,n)return{TYPE="FunctionCall",FunctionName=e,Arguments=n}end
return e end)c['MathParser']=(function(...)local e=a("Helpers/Helpers")local u=a("Evaluator/Evaluator")local d=a("Lexer/Lexer")local i=a("Parser/Parser")local e={}function e:tokenize(e)if self.cachedTokens[e]then
return self.cachedTokens[e]end
self.Lexer.resetToInitialState(e,self.operators)local n=self.Lexer.run()self.cachedTokens[e]=n
return n
end
function e:parse(n,e)if self.cachedASTs[e]then
return self.cachedASTs[e]end
self.Parser.resetToInitialState(n,self.operatorPrecedenceLevels,nil,e,self.functions)local n=self.Parser.parse()self.cachedASTs[e]=n
return n
end
function e:evaluate(e,o)if o and self.cachedResults[e]~=nil then
return self.cachedResults[e]end
self.Evaluator.resetToInitialState(e,self.variables,self.operatorFunctions,self.functions)local n=self.Evaluator:evaluate()if o then
self.cachedResults[e]=n
end
return n
end
function e:solve(e)return self:evaluate(self:parse(self:tokenize(e),e))end
function e:addVariable(n,e)self.variables=self.variables or{}self.variables[n]=e
self.cachedResults={}end
function e:addVariables(e)for e,n in pairs(e)do
self:addVariable(e,n)end
self.cachedResults={}end
function e:addFunction(n,e)self.functions=self.functions or{}self.functions[n]=e
self.cachedResults={}end
function e:removeFunction(e)if self.functions and self.functions[e]then
self.functions[e]=nil
self.cachedResults={}end
end
function e:addFunctions(e)for e,n in pairs(e)do
self:addFunction(e,n)end
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
function e:resetToInitialState(l,e,t,o,n)self.operatorPrecedenceLevels=l
self.variables=e
self.operatorFunctions=t
self.operators=o
self.functions=n
self.cachedTokens={}self.cachedASTs={}self.cachedResults={}end
local c={}function c:new(a,o,r,l,t)local n={}for t,e in pairs(e)do
n[t]=e
end
o=o or{}o['false']=false
o['true']=true
n.operatorPrecedenceLevels=a
n.variables=o
n.operatorFunctions=r
n.operators=l
n.functions=t
n.cachedTokens={}n.cachedASTs={}n.cachedResults={}n.Lexer=d(nil,l)n.Parser=i(nil,a)n.Evaluator=u(nil,o,r,t)return n
end
return c
end)local e,n="LibFormula-1.0",1
local n,e=LibStub and LibStub:NewLibrary(e,n)or{}if not n then return end
local e={}function n:CreateInstance()return e:new()end
local o=a('MathParser')function e:new()local e=setmetatable({__vm=o:new()},{__index=self})assert(e.__vm,'Invalid instance object')return e
end
function e:addFunc(n,e)self.__vm:addFunction(n,e)end
function e:removeFunc(e)self.__vm:removeFunction(e)end
function e:exec(e)return self.__vm:evaluate(e)end
function e:parse(e)return self.__vm:parse(self.__vm:tokenize(e),e)end
function e:perform(e)return self.__vm:solve(e)end
return n
