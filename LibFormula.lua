local c={}local r={}local o={}local function a(e)local n=r[e]if n then
return n
end
if o[e]then
error('critical dependency',2)end
o[e]=true
n=c[e]()o[e]=false
r[e]=n
return n
end
c['Helpers/Helpers']=(function(...)local l=string.char
local t=string.match
local a=string.gmatch
local c=table.insert
local o=string.utf8len or string.len
local r=string.utf8sub or string.sub
local n={}function n.stringToTable(e)local n={}for o=1,o(e)do
local e=r(e,o,o)c(n,e)end
return n
end
function n.createPatternLookupTable(o)local n={}for e=0,255 do
local e=l(e)if t(e,o)then
n[e]=true
end
end
return n
end
function n.makeTrie(e)local o={}for e,r in ipairs(e)do
local e=o
for n in a(r,".")do
e[n]=e[n]or{}e=e[n]end
e.value=r
end
return o
end
return n end)c['Evaluator/Evaluator']=(function(...)local e=a("Helpers/Helpers")local h=(unpack or table.unpack)local p=table.insert
local c={Unary={["-"]=function(e)return-e end,["!"]=function(e)return not e end,},Binary={["+"]=function(e,n)return e+n end,["-"]=function(e,n)return e-n end,["/"]=function(e,n)return e/n end,["*"]=function(e,n)return e*n end,["^"]=function(n,e)return n^e end,["%"]=function(e,n)return e%n end,["=="]=function(n,e)return n==e end,["!="]=function(n,e)return n~=e end,[">"]=function(e,n)return e>n end,["<"]=function(n,e)return n<e end,[">="]=function(n,e)return n>=e end,["<="]=function(n,e)return n<=e end,["||"]=function(e,n)return not not e or not not n end,["&&"]=function(n,e)return not not(n and e)end,[":="]=function(n,o,r,e)e[n]=o end,}}local u={sin=math.sin,cos=math.cos,tan=math.tan,asin=math.asin,acos=math.acos,atan=math.atan,floor=math.floor,ceil=math.ceil,abs=math.abs,sqrt=math.sqrt,log=math.log,log10=math.log10,exp=math.exp,rad=math.rad,deg=math.deg}local function f(n,e,o,a)local r=n
local l=e or{}local t=o or c
local s=a or{}local n,d,a,i,o
function n(e)local n=e.Value
local r=t.Unary[n]assert(r,"invalid operator: "..tostring(n))local n=o(e.Operand)return r(n,e)end
function d(e)local n=e.Value
local a=e.Left
local r=e.Right
local n=t.Binary[n]assert(n,"invalid operator")local t=o(r)local o=o(a,r)return n(o,t,e,l)end
function a(e)local o=not(not e.Operand)if o then
return n(e)end
return d(e)end
function i(n)local e=n.FunctionName
local r=n.Arguments
local n=s[e]or u[e]assert(n,"invalid function call: "..tostring(e))local e={}for r,n in ipairs(r)do
local n=o(n)p(e,n)end
return n(h(e))end
function o(e,o)local n=e.TYPE
if n=="Constant"then
return tonumber(e.Value)elseif n=="Variable"then
local n=l[e.Value]if n==nil then
if o~=nil then
return tostring(e.Value)end
return error("Variable not found: "..tostring(e.Value))end
return n
elseif n=="Operator"or n=="UnaryOperator"then
return a(e)elseif n=="FunctionCall"then
return i(e)elseif n=="String"then
return tostring(e.Value)end
return error("Invalid node type: "..tostring(n).." ( You're not supposed to see this error message. )")end
local function i(o,a,n,e)r=o
l=a or{}t=n or c
s=e or u
end
local function e()assert(r,"No expression to evaluate")return o(r)end
return{resetToInitialState=i,evaluate=e}end
return f end)c['Lexer/Lexer']=(function(...)local e=a("Helpers/Helpers")local n=a("Lexer/TokenFactory")local h=e.makeTrie
local b=e.stringToTable
local e=e.createPatternLookupTable
local c=table.concat
local o=table.insert
local P=string.rep
local v=n.createConstantToken
local x=n.createVariableToken
local g=n.createParenthesesToken
local E=n.createOperatorToken
local V=n.createCommaToken
local k=n.createStrToken
local f="+------------------------------+"local O="Expected a number after the 'x' or 'X'"local y="Expected a number after the decimal point"local U="Expected a number after the exponent sign"local n="Invalid character '%s'. Expected whitespace, parenthesis, comma, operator, or number."local F="No charStream given"local u={"+","-","*","/","^","%","==","!","!=",">","<",">=","<=","||",'&&',":=",}local m=h(u)local S=e("%s")local a=e("%d")local Y=e("[a-zA-Z_%.]")local p=e("[%da-fA-F]")local L=e("[+-]")local w=e("[eE]")local R=e("[xX]")local N=e("[a-zA-Z0-9_%.]")local C=e("[()]")local function A(e,r,s)local d={}local i={}local t,l,n
if e then
e=e
t=b(e)l=t[s or 1]n=s or 1
d[e]=t
end
local e=(r and h(r))or m
local _=r or u
local T=e
local function e()return t[n+1]or"\0"end
local function r(e)local e=n+(e or 1)local o=t[e]or"\0"n=e
l=o
return o
end
local function s(e,o)local n=n+(o or 0)local n=P(" ",n-1).."^"local e="\n"..c(t).."\n"..n.."\n"..e
return e
end
local function P()local e=i
if#e>0 then
local e=c(e,"\n"..f)error("Lexer errors:".."\n"..f..e.."\n"..f)end
end
local function A(n)local n=(n or l)return a[n]or(n=="."and a[e()])end
local function H(n)o(n,r())local t=p[e()]if not t then
local e=s(O,1)o(i,e)end
repeat
o(n,r())t=p[e()]until not t
return n
end
local function O(t)o(t,r())local n=a[e()]if not n then
local e=s(y,1)o(i,e)end
repeat
o(t,r())n=a[e()]until not n
return t
end
local function f(n)o(n,r())if L[e()]then
o(n,r())end
local t=a[e()]if not t then
local e=s(U,1)o(i,e)end
repeat
o(n,r())t=a[e()]until not t
return n
end
local function p()local n={l}local t=false
local t=false
local t=false
if l=='0'and R[e()]then
return c(H(n))end
while a[e()]do
o(n,r())end
if e()=="."then
n=O(n)end
local e=e()if w[e]then
n=f(n)end
return c(n)end
local function a()local n={l}while e()~=','and e()~=')'do
o(n,r())end
return c(n)end
local function s()local o,n={},0
local t
repeat
n=n+1
o[n]=l
local e=e()until not(N[e]and r())return c(o)end
local function f()if A(l)then
local e=p()return v(e,n)end
local e=a()return k(e,n)end
local function c()local o=T
local t=t
local l=n
local e
local n=0
while true do
local r=t[l+n]o=o[r]if not o then break end
e=o.value
n=n+1
end
if not e then return end
r(#e-1)return e
end
local function a()local e=l
if S[e]then
return
elseif C[e]then
return g(e,n)elseif Y[e]then
return x(s(),n)elseif e==","then
return V(n)else
local e=c()if e then
return E(e,n)end
return f()end
end
local function c()local n,e={},0
local o=l
while o~="\0"do
local t=a()if t then
e=e+1
n[e]=t
end
o=r()end
return n
end
local function r(e,o)if e then
e=e
t=d[e]or b(e)l=t[1]n=1
d[e]=t
end
T=(o and h(o))or m
_=o or u
end
local function e()assert(t,F)i={}local e=c()P()return e
end
return{resetToInitialState=r,run=e}end
return A end)c['Lexer/TokenFactory']=(function(...)local e={}function e.createConstantToken(e,n)return{TYPE="Constant",Value=e,Position=n}end
function e.createVariableToken(n,e)return{TYPE="Variable",Value=n,Position=e}end
function e.createParenthesesToken(n,e)return{TYPE="Parentheses",Value=n,Position=e}end
function e.createOperatorToken(e,n)return{TYPE="Operator",Value=e,Position=n}end
function e.createCommaToken(e)return{TYPE="Comma",Value=",",Position=e}end
function e.createStrToken(e,n)return{TYPE="String",Value=e,Position=n}end
return e end)c['Parser/Parser']=(function(...)local n=a("Helpers/Helpers")local e=a("Parser/NodeFactory")local T=n.stringToTable
local s=table.insert
local n=table.concat
local h=math.max
local i=math.min
local L=string.rep
local Y=e.createUnaryOperatorNode
local F=e.createOperatorNode
local R=e.createFunctionCallNode
local a=20
local O="No tokens given"local S="No tokens to parse"local y="Expected EOF, got '%s'"local x="Unexpected token: '%s' in <primary>, expected constant, variable or function call"local u="Expected expression, got EOF"local p="Expected ')', got EOF"local b="Expected ',' or ')', got '%s'"local c="<No charStream, error message: %s>"local f={Unary={["-"]=7,["!"]=7,},Binary={[":="]=1,["&&"]=2,["||"]=3,["=="]=4,["!="]=4,[">"]=4,["<"]=4,[">="]=4,["<="]=4,["+"]=5,["-"]=5,["*"]=6,["/"]=6,["%"]=6,["^"]=7,},RightAssociativeBinaryOperators={["^"]=true},}local e={}local function k(l,r,o,n)local t,e
if l then
t=o or 1
e=l[t]end
local o=r or f
local d=n
local function m(e)return l[t+(e or 1)]end
local function n(n)local o=t+(n or 1)local n=l[o]t=o
e=n
return n
end
local function E(n)local e=n or e
if not o.Binary then return end
return e and e.TYPE=="Operator"and o.Binary[e.Value]end
local function V(n)local e=n or e
if not o.Unary then return end
return e and e.TYPE=="Operator"and o.Unary[e.Value]end
local function v(n)local e=n or e
if not o.RightAssociativeBinaryOperators then return end
return e and e.TYPE=="Operator"and o.RightAssociativeBinaryOperators[e.Value]end
local function P()local n=m()if not n then return end
return e.TYPE=="Variable"and n.TYPE=="Parentheses"and n.Value=="("end
local function g(e)return e and o.Binary[e.Value]end
local function r(o,...)if not d then
return c:format(o)end
local n=T(d)local r=o:format(...)local e=(not e and#n+1)or e.Position
local o={}for e=h(1,e-a),i(e+a,#n)do
s(o,n[e])end
local n=table.concat(o)local e=L(" ",e-1).."^"return"\n"..n.."\n"..e.."\n"..r
end
local T,c,i,h,a
function T()local t=e.Value
n(2)local o={}while true do
local t=a()s(o,t)if not e then
local e=m(-1)if e.TYPE=="Comma"then
error(r(u))end
error(r(p))elseif e.Value==")"then
break
elseif e.TYPE=="Comma"then
n()else
error(r(b,e.Value))end
end
n()return R(t,o)end
function c(l)local o=i()while E(e)do
local t=g(e)if t<=l and not v(e)then
break
end
local l=e
if not n()then
error(r(u))end
local e=c(t)o=F(l.Value,o,e)end
return o
end
function i()if not V(e)then
return h()end
local o=e.Value
if not n()then
error(r(u))end
local e=i()return Y(o,e)end
function h()local o=e
if not o then return end
local l=o.Value
local t=o.TYPE
if t=="Parentheses"and l=="("then
n()local o=a()if not e or e.Value~=")"then
error(r(p))end
n()return o
elseif t=="Variable"then
if P()then
return T()end
n()return o
elseif t=="Constant"or t=="String"then
n()return o
end
error(r(x,l))end
function a()local e=c(0)return e
end
local function c(n,a,r,c)assert(n,O)l=n
t=r or 1
e=n[t]o=a or f
d=c
end
local function n(o)assert(l,S)local n=a()if e and not o then
error(r(y,e.Value))end
return n
end
return{resetToInitialState=c,parse=n}end
return k end)c['Parser/NodeFactory']=(function(...)local e={}function e.createUnaryOperatorNode(e,n)return{TYPE="UnaryOperator",Value=e,Operand=n}end
function e.createOperatorNode(e,n,o)return{TYPE="Operator",Value=e,Left=n,Right=o}end
function e.createFunctionCallNode(n,e)return{TYPE="FunctionCall",FunctionName=n,Arguments=e}end
return e end)c['MathParser']=(function(...)local e=a("Helpers/Helpers")local i=a("Evaluator/Evaluator")local u=a("Lexer/Lexer")local d=a("Parser/Parser")local e={}function e:tokenize(e)if self.cachedTokens[e]then
return self.cachedTokens[e]end
self.Lexer.resetToInitialState(e,self.operators)local n=self.Lexer.run()self.cachedTokens[e]=n
return n
end
function e:parse(n,e)if self.cachedASTs[e]then
return self.cachedASTs[e]end
self.Parser.resetToInitialState(n,self.operatorPrecedenceLevels,nil,e)local n=self.Parser.parse()self.cachedASTs[e]=n
return n
end
function e:evaluate(e)if self.cachedResults[e]then
return self.cachedResults[e]end
self.Evaluator.resetToInitialState(e,self.variables,self.operatorFunctions,self.functions)local n=self.Evaluator:evaluate()self.cachedResults[e]=n
return n
end
function e:solve(e)return self:evaluate(self:parse(self:tokenize(e),e))end
function e:addVariable(e,n)self.variables=self.variables or{}self.variables[e]=n
self.cachedResults={}end
function e:addVariables(e)for n,e in pairs(e)do
self:addVariable(n,e)end
self.cachedResults={}end
function e:addFunction(e,n)self.functions=self.functions or{}self.functions[e]=n
self.cachedResults={}end
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
function e:resetToInitialState(e,n,o,t,r)self.operatorPrecedenceLevels=e
self.variables=n
self.operatorFunctions=o
self.operators=t
self.functions=r
self.cachedTokens={}self.cachedASTs={}self.cachedResults={}end
local c={}function c:new(a,o,r,t,l)local n={}for e,r in pairs(e)do
n[e]=r
end
o=o or{}o['false']=false
o['true']=true
n.operatorPrecedenceLevels=a
n.variables=o
n.operatorFunctions=r
n.operators=t
n.functions=l
n.cachedTokens={}n.cachedASTs={}n.cachedResults={}n.Lexer=u(nil,t)n.Parser=d(nil,a)n.Evaluator=i(nil,o,r,l)return n
end
return c end)local n,e="LibFormula-1.0",1
local n,e=LibStub and LibStub:NewLibrary(n,e)or{}if not n then return end
local e={}function n:CreateInstance()return e:new()end
local o=a('MathParser')function e:new()local e=setmetatable({__vm=o:new()},{__index=self})assert(e.__vm,'Invalid instance object')return e
end
function e:addFunc(e,n)self.__vm:addFunction(e,n)end
function e:exec(e)return self.__vm:evaluate(e)end
function e:parse(e)return self.__vm:parse(self.__vm:tokenize(e),e)end
function e:perform(e)return self.__vm:solve(e)end
return n
