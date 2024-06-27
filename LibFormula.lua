local c={}local l={}local o={}local function a(e)local n=l[e]if n then
return n
end
if o[e]then
error('critical dependency',2)end
o[e]=true
n=c[e]()o[e]=false
l[e]=n
return n
end
c['Helpers/Helpers']=(function(...)local t=string.char
local r=string.match
local a=string.gmatch
local i=table.insert
local c=string.utf8len or string.len
local l=string.utf8sub or string.sub
local n={}function n.stringToTable(e)local o={}for n=1,c(e)do
local e=l(e,n,n)i(o,e)end
return o
end
function n.createPatternLookupTable(o)local e={}for n=0,255 do
local n=t(n)if r(n,o)then
e[n]=true
end
end
return e
end
function n.makeTrie(e)local o={}for e,l in ipairs(e)do
local e=o
for n in a(l,".")do
e[n]=e[n]or{}e=e[n]end
e.value=l
end
return o
end
return n end)c['Evaluator/Evaluator']=(function(...)local e=a("Helpers/Helpers")local p=(unpack or table.unpack)local T=table.insert
local a={Unary={["-"]=function(e)return-e end,["!"]=function(e)return not e end,},Binary={["+"]=function(e,n)return e+n end,["-"]=function(e,n)return e-n end,["/"]=function(e,n)return e/n end,["*"]=function(e,n)return e*n end,["^"]=function(n,e)return n^e end,["%"]=function(e,n)return e%n end,["=="]=function(n,e)return n==e end,["!="]=function(n,e)return n~=e end,[">"]=function(e,n)return e>n end,["<"]=function(e,n)return e<n end,[">="]=function(e,n)return e>=n end,["<="]=function(n,e)return n<=e end,["||"]=function(n,e)return not not n or not not e end,["||||"]=function(e,n)return not not e or not not n end,["&&"]=function(e,n)return not not(e and n)end,[":="]=function(n,o,l,e)e[n]=o end,}}local f={sin=math.sin,cos=math.cos,tan=math.tan,asin=math.asin,acos=math.acos,atan=math.atan,floor=math.floor,ceil=math.ceil,abs=math.abs,sqrt=math.sqrt,log=math.log,log10=math.log10,exp=math.exp,rad=math.rad,deg=math.deg}local function h(n,e,o,c)local t=n
local l=e or{}local r=o or a
local s=c or{}local d,u,i,c,o
function d(e)local n=e.Value
local l=r.Unary[n]assert(l,"invalid operator: "..tostring(n))local n=o(e.Operand)return l(n,e)end
function u(e)local n=e.Value
local t=e.Left
local a=e.Right
local n=r.Binary[n]assert(n,"invalid operator")local r=o(t)local o=o(a)return n(r,o,e,l)end
function i(e)local n=not(not e.Operand)if n then
return d(e)end
return u(e)end
function c(n)local e=n.FunctionName
local l=n.Arguments
local n=s[e]or f[e]assert(n,"invalid function call: "..tostring(e))local e={}for l,n in ipairs(l)do
local n=o(n)T(e,n)end
return n(p(e))end
function o(e)local n=e.TYPE
if n=="Constant"then
return tonumber(e.Value)elseif n=="Variable"then
local n=l[e.Value]if n==nil then
return tostring(e.Value)end
return n
elseif n=="Operator"or n=="UnaryOperator"then
return i(e)elseif n=="FunctionCall"then
return c(e)elseif n=="String"then
return tostring(e.Value)end
return error("Invalid node type: "..tostring(n).." ( You're not supposed to see this error message. )")end
local function i(o,c,n,e)t=o
l=c or{}r=n or a
s=e or f
end
local function e()assert(t,"No expression to evaluate")return o(t)end
return{resetToInitialState=i,evaluate=e}end
return h end)c['Lexer/Lexer']=(function(...)local e=a("Helpers/Helpers")local n=a("Lexer/TokenFactory")local h=e.makeTrie
local b=e.stringToTable
local e=e.createPatternLookupTable
local c=table.concat
local l=table.insert
local P=string.rep
local v=n.createConstantToken
local x=n.createVariableToken
local g=n.createParenthesesToken
local E=n.createOperatorToken
local k=n.createCommaToken
local V=n.createStrToken
local d="+------------------------------+"local O="Expected a number after the 'x' or 'X'"local y="Expected a number after the decimal point"local w="Expected a number after the exponent sign"local n="Invalid character '%s'. Expected whitespace, parenthesis, comma, operator, or number."local U="No charStream given"local p={"+","-","*","/","^","%","==","!","!=",">","<",">=","<=","||","||||",'&&',":=",}local T=h(p)local S=e("%s")local a=e("%d")local L=e("[a-zA-Z_%.]")local m=e("[%da-fA-F]")local _=e("[+-]")local F=e("[eE]")local N=e("[xX]")local C=e("[a-zA-Z0-9_%.]")local A=e("[()]")local function R(n,o,u)local s={}local i={}local r,t,e
if n then
n=n
r=b(n)t=r[u or 1]e=u or 1
s[n]=r
end
local n=(o and h(o))or T
local Y=o or p
local f=n
local function n()return r[e+1]or"\0"end
local function o(n)local o=e+(n or 1)local n=r[o]or"\0"e=o
t=n
return n
end
local function u(n,o)local e=e+(o or 0)local e=P(" ",e-1).."^"local e="\n"..c(r).."\n"..e.."\n"..n
return e
end
local function P()local e=i
if#e>0 then
local e=c(e,"\n"..d)error("Lexer errors:".."\n"..d..e.."\n"..d)end
end
local function H(e)local e=(e or t)return a[e]or(e=="."and a[n()])end
local function R(e)l(e,o())local r=m[n()]if not r then
local e=u(O,1)l(i,e)end
repeat
l(e,o())r=m[n()]until not r
return e
end
local function O(r)l(r,o())local e=a[n()]if not e then
local e=u(y,1)l(i,e)end
repeat
l(r,o())e=a[n()]until not e
return r
end
local function d(e)l(e,o())if _[n()]then
l(e,o())end
local r=a[n()]if not r then
local e=u(w,1)l(i,e)end
repeat
l(e,o())r=a[n()]until not r
return e
end
local function m()local e={t}local r=false
local r=false
local r=false
if t=='0'and N[n()]then
return c(R(e))end
while a[n()]do
l(e,o())end
if n()=="."then
e=O(e)end
local n=n()if F[n]then
e=d(e)end
return c(e)end
local function d()local t={t}local a=f
local r=r
local e=e
local n=1
while true do
local e=r[e+n]if not e or a[e]or e==")"or e==","then break end
n=n+1
l(t,e)end
if n>0 then
o(n-1)end
return c(t)end
local function u()local l,e={},0
local r
repeat
e=e+1
l[e]=t
local e=n()until not(C[e]and o())return c(l)end
local function c()if H(t)then
local n=m()return v(n,e)end
local n=d()return V(n,e)end
local function a()local n=f
local t=r
local r=e
local e
local l=0
while true do
local o=t[r+l]n=n[o]if not n then break end
e=n.value
l=l+1
end
if not e then return end
o(#e-1)return e
end
local function l()local n=t
if S[n]then
return
elseif A[n]then
return g(n,e)elseif L[n]then
return x(u(),e)elseif n==","then
return k(e)else
local n=a()if n then
return E(n,e)end
return c()end
end
local function a()local n,e={},0
local r=t
while r~="\0"do
local l=l()if l then
e=e+1
n[e]=l
end
r=o()end
return n
end
local function l(n,o)if n then
n=n
r=s[n]or b(n)t=r[1]e=1
s[n]=r
end
f=(o and h(o))or T
Y=o or p
end
local function e()assert(r,U)i={}local e=a()P()return e
end
return{resetToInitialState=l,run=e}end
return R end)c['Lexer/TokenFactory']=(function(...)local e={}function e.createConstantToken(e,n)return{TYPE="Constant",Value=e,Position=n}end
function e.createVariableToken(e,n)return{TYPE="Variable",Value=e,Position=n}end
function e.createParenthesesToken(e,n)return{TYPE="Parentheses",Value=e,Position=n}end
function e.createOperatorToken(n,e)return{TYPE="Operator",Value=n,Position=e}end
function e.createCommaToken(e)return{TYPE="Comma",Value=",",Position=e}end
function e.createStrToken(n,e)return{TYPE="String",Value=n,Position=e}end
return e end)c['Parser/Parser']=(function(...)local n=a("Helpers/Helpers")local e=a("Parser/NodeFactory")local f=n.stringToTable
local m=table.insert
local n=table.concat
local s=math.max
local h=math.min
local Y=string.rep
local F=e.createUnaryOperatorNode
local R=e.createOperatorNode
local L=e.createFunctionCallNode
local a=20
local S="No tokens given"local O="No tokens to parse"local E="Expected EOF, got '%s'"local k="Unexpected token: '%s' in <primary>, expected constant, variable or function call"local i="Expected expression, got EOF"local p="Expected ')', got EOF"local v="Expected ',' or ')', got '%s'"local d="<No charStream, error message: %s>"local T={Unary={["-"]=7,["!"]=7,},Binary={[":="]=1,["&&"]=2,["||"]=3,["||||"]=3,["=="]=4,["!="]=4,[">"]=4,["<"]=4,[">="]=4,["<="]=4,["+"]=5,["-"]=5,["*"]=6,["/"]=6,["%"]=6,["^"]=7,},RightAssociativeBinaryOperators={["^"]=true},}local e={}local function x(t,n,l,o,u)local r,e
if t then
r=l or 1
e=t[r]end
local l=n or T
local c=o
local u=u
local function b(e)return t[r+(e or 1)]end
local function n(n)local o=r+(n or 1)local n=t[o]r=o
e=n
return n
end
local function g(n)local e=n or e
if not l.Binary then return end
return e and e.TYPE=="Operator"and l.Binary[e.Value]end
local function y(n)local e=n or e
if not l.Unary then return end
return e and e.TYPE=="Operator"and l.Unary[e.Value]end
local function x(n)local e=n or e
if not l.RightAssociativeBinaryOperators then return end
return e and e.TYPE=="Operator"and l.RightAssociativeBinaryOperators[e.Value]end
local function V()local n=b()if not n then
return e.TYPE=="Variable"and u and u[e.Value]~=nil
end
return e.TYPE=="Variable"and n.TYPE=="Parentheses"and n.Value=="("end
local function P(e)return e and l.Binary[e.Value]end
local function o(o,...)if not c then
return d:format(o)end
local n=f(c)local l=o:format(...)local e=(not e and#n+1)or e.Position
local o={}for e=s(1,e-a),h(e+a,#n)do
m(o,n[e])end
local n=table.concat(o)local e=Y(" ",e-1).."^"return"\n"..n.."\n"..e.."\n"..l
end
local f,d,s,h,a
function f()local r=e.Value
n(2)local l={}while true do
local r=a()m(l,r)if not e then
local e=b(-1)if not e then
break
end
if e.TYPE=="Comma"then
error(o(i))end
error(o(p))elseif e.Value==")"then
break
elseif e.TYPE=="Comma"then
n()else
error(o(v,e.Value))end
end
n()return L(r,l)end
function d(t)local l=s()while g(e)do
local r=P(e)if r<=t and not x(e)then
break
end
local t=e
if not n()then
error(o(i))end
local e=d(r)l=R(t.Value,l,e)end
return l
end
function s()if not y(e)then
return h()end
local l=e.Value
if not n()then
error(o(i))end
local e=s()return F(l,e)end
function h()local l=e
if not l then return end
local t=l.Value
local r=l.TYPE
if r=="Parentheses"and t=="("then
n()local l=a()if not e or e.Value~=")"then
error(o(p))end
n()return l
elseif r=="Variable"then
if V()then
return f()end
n()return l
elseif r=="Constant"or r=="String"then
n()return l
end
error(o(k,t))end
function a()local e=d(0)return e
end
local function i(n,d,a,i,o)assert(n,S)t=n
r=a or 1
e=n[r]l=d or T
c=i
u=o
end
local function l(n)assert(t,O)local l=a()if e and not n then
error(o(E,e.Value))end
return l
end
return{resetToInitialState=i,parse=l}end
return x end)c['Parser/NodeFactory']=(function(...)local e={}function e.createUnaryOperatorNode(n,e)return{TYPE="UnaryOperator",Value=n,Operand=e}end
function e.createOperatorNode(o,n,e)return{TYPE="Operator",Value=o,Left=n,Right=e}end
function e.createFunctionCallNode(e,n)return{TYPE="FunctionCall",FunctionName=e,Arguments=n}end
return e end)c['MathParser']=(function(...)local e=a("Helpers/Helpers")local i=a("Evaluator/Evaluator")local u=a("Lexer/Lexer")local c=a("Parser/Parser")local e={}function e:tokenize(e)if self.cachedTokens[e]then
return self.cachedTokens[e]end
self.Lexer.resetToInitialState(e,self.operators)local n=self.Lexer.run()self.cachedTokens[e]=n
return n
end
function e:parse(n,e)if self.cachedASTs[e]then
return self.cachedASTs[e]end
self.Parser.resetToInitialState(n,self.operatorPrecedenceLevels,nil,e,self.functions)local n=self.Parser.parse()self.cachedASTs[e]=n
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
function e:addFunction(n,e)self.functions=self.functions or{}self.functions[n]=e
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
function e:resetToInitialState(r,l,o,e,n)self.operatorPrecedenceLevels=r
self.variables=l
self.operatorFunctions=o
self.operators=e
self.functions=n
self.cachedTokens={}self.cachedASTs={}self.cachedResults={}end
local a={}function a:new(r,o,t,l,a)local n={}for e,l in pairs(e)do
n[e]=l
end
o=o or{}o['false']=false
o['true']=true
n.operatorPrecedenceLevels=r
n.variables=o
n.operatorFunctions=t
n.operators=l
n.functions=a
n.cachedTokens={}n.cachedASTs={}n.cachedResults={}n.Lexer=u(nil,l)n.Parser=c(nil,r)n.Evaluator=i(nil,o,t,a)return n
end
return a end)local n,e="LibFormula-1.0",1
local n,e=LibStub and LibStub:NewLibrary(n,e)or{}if not n then return end
local e={}function n:CreateInstance()return e:new()end
local o=a('MathParser')function e:new()local e=setmetatable({__vm=o:new()},{__index=self})assert(e.__vm,'Invalid instance object')return e
end
function e:addFunc(e,n)self.__vm:addFunction(e,n)end
function e:exec(e)return self.__vm:evaluate(e)end
function e:parse(e)return self.__vm:parse(self.__vm:tokenize(e),e)end
function e:perform(e)return self.__vm:solve(e)end
return n
