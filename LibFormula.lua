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
local l=string.match
local a=string.gmatch
local i=table.insert
local c=string.utf8len or string.len
local t=string.utf8sub or string.sub
local n={}function n.stringToTable(e)local o={}for n=1,c(e)do
local e=t(e,n,n)i(o,e)end
return o
end
function n.createPatternLookupTable(o)local e={}for n=0,255 do
local n=r(n)if l(n,o)then
e[n]=true
end
end
return e
end
function n.makeTrie(e)local o={}for e,t in ipairs(e)do
local e=o
for n in a(t,".")do
e[n]=e[n]or{}e=e[n]end
e.value=t
end
return o
end
return n end)c['Evaluator/Evaluator']=(function(...)local e=a("Helpers/Helpers")local p=(unpack or table.unpack)local m=table.insert
local a={Unary={["-"]=function(e)return-e end,["!"]=function(e)return not e end,},Binary={["+"]=function(e,n)return e+n end,["-"]=function(e,n)return e-n end,["/"]=function(e,n)return e/n end,["*"]=function(e,n)return e*n end,["^"]=function(n,e)return n^e end,["%"]=function(e,n)return e%n end,["=="]=function(n,e)return n==e end,["!="]=function(n,e)return n~=e end,[">"]=function(e,n)return e>n end,["<"]=function(e,n)return e<n end,[">="]=function(e,n)return e>=n end,["<="]=function(n,e)return n<=e end,["||"]=function(n,e)return not not n or not not e end,["||||"]=function(e,n)return not not e or not not n end,["&&"]=function(e,n)return not not(e and n)end,[":="]=function(n,o,t,e)e[n]=o end,}}local f={sin=math.sin,cos=math.cos,tan=math.tan,asin=math.asin,acos=math.acos,atan=math.atan,floor=math.floor,ceil=math.ceil,abs=math.abs,sqrt=math.sqrt,log=math.log,log10=math.log10,exp=math.exp,rad=math.rad,deg=math.deg}local function h(n,e,o,c)local r=n
local l=e or{}local t=o or a
local s=c or{}local d,u,i,c,o
function d(e)local n=e.Value
local t=t.Unary[n]assert(t,"invalid operator: "..tostring(n))local n=o(e.Operand)return t(n,e)end
function u(e)local n=e.Value
local r=e.Left
local a=e.Right
local n=t.Binary[n]assert(n,"invalid operator")local t=o(r)local o=o(a)return n(t,o,e,l)end
function i(e)local n=not(not e.Operand)if n then
return d(e)end
return u(e)end
function c(n)local e=n.FunctionName
local t=n.Arguments
local n=s[e]or f[e]assert(n,"invalid function call: "..tostring(e))local e={}for t,n in ipairs(t)do
local n=o(n)m(e,n)end
return n(p(e))end
function o(n)local e=n.TYPE
if e=="Constant"then
return tonumber(n.Value)elseif e=="Variable"then
local e=l[n.Value]if e==nil then
return tostring(n.Value)end
return e
elseif e=="Operator"or e=="UnaryOperator"then
return i(n)elseif e=="FunctionCall"then
return c(n)elseif e=="String"then
return tostring(n.Value)end
return error("Invalid node type: "..tostring(e).." ( You're not supposed to see this error message. )")end
local function i(o,c,n,e)r=o
l=c or{}t=n or a
s=e or f
end
local function e()assert(r,"No expression to evaluate")return o(r)end
return{resetToInitialState=i,evaluate=e}end
return h end)c['Lexer/Lexer']=(function(...)local e=a("Helpers/Helpers")local n=a("Lexer/TokenFactory")local h=e.makeTrie
local b=e.stringToTable
local e=e.createPatternLookupTable
local c=table.concat
local t=table.insert
local P=string.rep
local v=n.createConstantToken
local x=n.createVariableToken
local g=n.createParenthesesToken
local k=n.createOperatorToken
local E=n.createCommaToken
local V=n.createStrToken
local f="+------------------------------+"local O="Expected a number after the 'x' or 'X'"local y="Expected a number after the decimal point"local w="Expected a number after the exponent sign"local n="Invalid character '%s'. Expected whitespace, parenthesis, comma, operator, or number."local U="No charStream given"local p={"+","-","*","/","^","%","==","!","!=",">","<",">=","<=","||","||||",'&&',":=",}local m=h(p)local S=e("%s")local a=e("%d")local L=e("[a-zA-Z_%.]")local T=e("[%da-fA-F]")local _=e("[+-]")local F=e("[eE]")local N=e("[xX]")local C=e("[a-zA-Z0-9_%.]")local A=e("[()]")local function R(n,o,u)local s={}local i={}local l,r,e
if n then
n=n
l=b(n)r=l[u or 1]e=u or 1
s[n]=l
end
local n=(o and h(o))or m
local Y=o or p
local u=n
local function n()return l[e+1]or"\0"end
local function o(n)local o=e+(n or 1)local n=l[o]or"\0"e=o
r=n
return n
end
local function d(n,o)local e=e+(o or 0)local e=P(" ",e-1).."^"local e="\n"..c(l).."\n"..e.."\n"..n
return e
end
local function P()local e=i
if#e>0 then
local e=c(e,"\n"..f)error("Lexer errors:".."\n"..f..e.."\n"..f)end
end
local function H(e)local e=(e or r)return a[e]or(e=="."and a[n()])end
local function R(e)t(e,o())local l=T[n()]if not l then
local e=d(O,1)t(i,e)end
repeat
t(e,o())l=T[n()]until not l
return e
end
local function O(e)t(e,o())local l=a[n()]if not l then
local e=d(y,1)t(i,e)end
repeat
t(e,o())l=a[n()]until not l
return e
end
local function f(e)t(e,o())if _[n()]then
t(e,o())end
local l=a[n()]if not l then
local e=d(w,1)t(i,e)end
repeat
t(e,o())l=a[n()]until not l
return e
end
local function T()local e={r}local l=false
local l=false
local l=false
if r=='0'and N[n()]then
return tonumber(c(R(e)),16)end
while a[n()]do
t(e,o())end
if n()=="."then
e=O(e)end
local n=n()if F[n]then
e=f(e)end
return tonumber(c(e))end
local function f()local r={r}local a=u
local l=l
local e=e
local n=1
while true do
local e=l[e+n]if not e or a[e]or e==")"or e==","then break end
n=n+1
t(r,e)end
if n>0 then
o(n-1)end
return c(r)end
local function d()local t,e={},0
local l
repeat
e=e+1
t[e]=r
local e=n()until not(C[e]and o())return c(t)end
local function c()if H(r)then
local n=T()return v(n,e)end
local n=f()return V(n,e)end
local function a()local n=u
local r=l
local l=e
local e
local t=0
while true do
local o=r[l+t]n=n[o]if not n then break end
e=n.value
t=t+1
end
if not e then return end
o(#e-1)return e
end
local function t()local n=r
if S[n]then
return
elseif A[n]then
return g(n,e)elseif L[n]then
return x(d(),e)elseif n==","then
return E(e)else
local n=a()if n then
return k(n,e)end
return c()end
end
local function a()local n,e={},0
local l=r
while l~="\0"do
local t=t()if t then
e=e+1
n[e]=t
end
l=o()end
return n
end
local function t(n,o)if n then
n=n
l=s[n]or b(n)r=l[1]e=1
s[n]=l
end
u=(o and h(o))or m
Y=o or p
end
local function e()assert(l,U)i={}local e=a()P()return e
end
return{resetToInitialState=t,run=e}end
return R
end)c['Lexer/TokenFactory']=(function(...)local e={}function e.createConstantToken(e,n)return{TYPE="Constant",Value=e,Position=n}end
function e.createVariableToken(e,n)return{TYPE="Variable",Value=e,Position=n}end
function e.createParenthesesToken(e,n)return{TYPE="Parentheses",Value=e,Position=n}end
function e.createOperatorToken(n,e)return{TYPE="Operator",Value=n,Position=e}end
function e.createCommaToken(e)return{TYPE="Comma",Value=",",Position=e}end
function e.createStrToken(n,e)return{TYPE="String",Value=n,Position=e}end
return e end)c['Parser/Parser']=(function(...)local n=a("Helpers/Helpers")local e=a("Parser/NodeFactory")local s=n.stringToTable
local p=table.insert
local n=table.concat
local d=math.max
local f=math.min
local Y=string.rep
local F=e.createUnaryOperatorNode
local R=e.createOperatorNode
local L=e.createFunctionCallNode
local a=20
local S="No tokens given"local O="No tokens to parse"local k="Expected EOF, got '%s'"local g="Unexpected token: '%s' in <primary>, expected constant, variable or function call"local i="Expected expression, got EOF"local v="Expected ')', got EOF"local b="Expected ',' or ')', got '%s'"local u="<No charStream, error message: %s>"local h={Unary={["-"]=7,["!"]=7,},Binary={[":="]=1,["&&"]=2,["||"]=3,["||||"]=3,["=="]=4,["!="]=4,[">"]=4,["<"]=4,[">="]=4,["<="]=4,["+"]=5,["-"]=5,["*"]=6,["/"]=6,["%"]=6,["^"]=7,},RightAssociativeBinaryOperators={["^"]=true},}local e={}local function V(r,c,o,l,n)local t,e
if r then
t=o or 1
e=r[t]end
local o=c or h
local c=l
local T=n
local function m(e)return r[t+(e or 1)]end
local function n(n)local o=t+(n or 1)local n=r[o]t=o
e=n
return n
end
local function E(n)local e=n or e
if not o.Binary then return end
return e and e.TYPE=="Operator"and o.Binary[e.Value]end
local function V(n)local e=n or e
if not o.Unary then return end
return e and e.TYPE=="Operator"and o.Unary[e.Value]end
local function y(n)local e=n or e
if not o.RightAssociativeBinaryOperators then return end
return e and e.TYPE=="Operator"and o.RightAssociativeBinaryOperators[e.Value]end
local function x()if T[e.Value]~=nil then
return true
end
local n=m()if not n then return end
return e.TYPE=="Variable"and n.TYPE=="Parentheses"and n.Value=="("end
local function P(e)return e and o.Binary[e.Value]end
local function l(o,...)if not c then
return u:format(o)end
local n=s(c)local t=o:format(...)local e=(not e and#n+1)or e.Position
local o={}for e=d(1,e-a),f(e+a,#n)do
p(o,n[e])end
local n=table.concat(o)local e=Y(" ",e-1).."^"return"\n"..n.."\n"..e.."\n"..t
end
local s,d,u,f,a
function s()local t=e.Value
n(2)local o={}while true do
local t=a()p(o,t)if not e then
local e=m(-1)if e and e.TYPE=="Comma"then
error(l(i))end
break
elseif e.Value==")"then
break
elseif e.TYPE=="Comma"then
n()else
error(l(b,e.Value))end
end
n()return L(t,o)end
function d(r)local o=u()while E(e)do
local t=P(e)if t<=r and not y(e)then
break
end
local r=e
if not n()then
error(l(i))end
local e=d(t)o=R(r.Value,o,e)end
return o
end
function u()if not V(e)then
return f()end
local o=e.Value
if not n()then
error(l(i))end
local e=u()return F(o,e)end
function f()local o=e
if not o then return end
local r=o.Value
local t=o.TYPE
if t=="Parentheses"and r=="("then
n()local o=a()if not e or e.Value~=")"then
error(l(v))end
n()return o
elseif t=="Variable"then
if x()then
return s()end
n()return o
elseif t=="Constant"or t=="String"then
n()return o
end
error(l(g,r))end
function a()local e=d(0)return e
end
local function i(n,u,a,i,l)assert(n,S)r=n
t=a or 1
e=n[t]o=u or h
c=i
T=l
end
local function o(n)assert(r,O)local o=a()if e and not n then
error(l(k,e.Value))end
return o
end
return{resetToInitialState=i,parse=o}end
return V
end)c['Parser/NodeFactory']=(function(...)local e={}function e.createUnaryOperatorNode(n,e)return{TYPE="UnaryOperator",Value=n,Operand=e}end
function e.createOperatorNode(o,n,e)return{TYPE="Operator",Value=o,Left=n,Right=e}end
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
function e:resetToInitialState(l,t,o,e,n)self.operatorPrecedenceLevels=l
self.variables=t
self.operatorFunctions=o
self.operators=e
self.functions=n
self.cachedTokens={}self.cachedASTs={}self.cachedResults={}end
local c={}function c:new(t,o,a,r,l)local n={}for e,t in pairs(e)do
n[e]=t
end
o=o or{}o['false']=false
o['true']=true
n.operatorPrecedenceLevels=t
n.variables=o
n.operatorFunctions=a
n.operators=r
n.functions=l
n.cachedTokens={}n.cachedASTs={}n.cachedResults={}n.Lexer=d(nil,r)n.Parser=i(nil,t)n.Evaluator=u(nil,o,a,l)return n
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
