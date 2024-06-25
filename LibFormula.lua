local c={}local a={}local o={}local function t(e)local n=a[e]if n then
return n
end
if o[e]then
error('critical dependency',2)end
o[e]=true
n=c[e]()o[e]=false
a[e]=n
return n
end
c['Helpers/Helpers']=(function(...)local r=string.char
local a=string.match
local o=string.gmatch
local l=table.insert
local n={}function n.stringToTable(n)local e={}for n in o(n,".")do
l(e,n)end
return e
end
function n.createPatternLookupTable(o)local n={}for e=0,255 do
local e=r(e)if a(e,o)then
n[e]=true
end
end
return n
end
function n.makeTrie(e)local o={}for e,a in ipairs(e)do
local e=o
for n in a:gmatch(".")do
e[n]=e[n]or{}e=e[n]end
e.value=a
end
return o
end
return n end)c['Evaluator/Evaluator']=(function(...)local e=t("Helpers/Helpers")local f=(unpack or table.unpack)local h=table.insert
local t={Unary={["-"]=function(e)return-e end,["!"]=function(e)return not e end,},Binary={["+"]=function(e,n)return e+n end,["-"]=function(n,e)return n-e end,["/"]=function(n,e)return n/e end,["*"]=function(n,e)return n*e end,["^"]=function(e,n)return e^n end,["%"]=function(n,e)return n%e end,["=="]=function(n,e)return n==e end,["!="]=function(e,n)return e~=n end,[">"]=function(n,e)return n>e end,["<"]=function(n,e)return n<e end,[">="]=function(n,e)return n>=e end,["<="]=function(e,n)return e<=n end,["||"]=function(n,e)return not not n or not not e end,["&&"]=function(e,n)return not not(e and n)end,[":="]=function(o,n,a,e)e[o]=n end,}}local s={sin=math.sin,cos=math.cos,tan=math.tan,asin=math.asin,acos=math.acos,atan=math.atan,floor=math.floor,ceil=math.ceil,abs=math.abs,sqrt=math.sqrt,log=math.log,log10=math.log10,exp=math.exp,rad=math.rad,deg=math.deg}local function p(e,o,n,c)local a=e
local r=o or{}local l=n or t
local d=c or{}local u,n,i,c,o
function u(e)local n=e.Value
local a=l.Unary[n]assert(a,"invalid operator: "..tostring(n))local n=o(e.Operand)return a(n,e)end
function n(e)local a=e.Value
local t=e.Left
local n=e.Right
local a=l.Binary[a]assert(a,"invalid operator")local l=o(n)local n=o(t,n)return a(n,l,e,r)end
function i(e)local o=not(not e.Operand)if o then
return u(e)end
return n(e)end
function c(n)local e=n.FunctionName
local a=n.Arguments
local n=d[e]or s[e]assert(n,"invalid function call: "..tostring(e))local e={}for a,n in ipairs(a)do
local n=o(n)h(e,n)end
return n(f(e))end
function o(e,o)local n=e.TYPE
if n=="Constant"then
return tonumber(e.Value)elseif n=="Variable"then
local n=r[e.Value]if n==nil then
if o~=nil then
return tostring(e.Value)end
return error("Variable not found: "..tostring(e.Value))end
return n
elseif n=="Operator"or n=="UnaryOperator"then
return i(e)elseif n=="FunctionCall"then
return c(e)end
return error("Invalid node type: "..tostring(n).." ( You're not supposed to see this error message. )")end
local function i(c,n,o,e)a=c
r=n or{}l=o or t
d=e or s
end
local function e()assert(a,"No expression to evaluate")return o(a)end
return{resetToInitialState=i,evaluate=e}end
return p end)c['Lexer/Lexer']=(function(...)local e=t("Helpers/Helpers")local o=t("Lexer/TokenFactory")local h=e.makeTrie
local b=e.stringToTable
local e=e.createPatternLookupTable
local i=table.concat
local n=table.insert
local F=string.rep
local O=o.createConstantToken
local L=o.createVariableToken
local y=o.createParenthesesToken
local g=o.createOperatorToken
local v=o.createCommaToken
local f="+------------------------------+"local P="Expected a number after the 'x' or 'X'"local E="Expected a number after the decimal point"local k="Expected a number after the exponent sign"local V="Invalid character '%s'. Expected whitespace, parenthesis, comma, operator, or number."local x="No charStream given"local s={"+","-","*","/","^","%","==","!","!=",">","<",">=","<=","||",'&&',":=",}local m=h(s)local Y=e("%s")local t=e("%d")local R=e("[a-zA-Z_%.]")local T=e("[%da-fA-F]")local A=e("[+-]")local _=e("[eE]")local I=e("[xX]")local U=e("[a-zA-Z0-9_%.]")local N=e("[()]")local function C(e,l,u)local d={}local c={}local r,a,o
if e then
e=e
r=b(e)a=r[u or 1]o=u or 1
d[e]=r
end
local e=(l and h(l))or m
local S=l or s
local p=e
local function e()return r[o+1]or"\0"end
local function l(e)local n=o+(e or 1)local e=r[n]or"\0"o=n
a=e
return e
end
local function u(e,n)local n=o+(n or 0)local n=F(" ",n-1).."^"local e="\n"..i(r).."\n"..n.."\n"..e
return e
end
local function C()local e=c
if#e>0 then
local e=i(e,"\n"..f)error("Lexer errors:".."\n"..f..e.."\n"..f)end
end
local function F(n)local n=(n or a)return t[n]or(n=="."and t[e()])end
local function f(a)n(a,l())local o=T[e()]if not o then
local e=u(P,1)n(c,e)end
repeat
n(a,l())o=T[e()]until not o
return a
end
local function T(a)n(a,l())local o=t[e()]if not o then
local e=u(E,1)n(c,e)end
repeat
n(a,l())o=t[e()]until not o
return a
end
local function P(o)n(o,l())if A[e()]then
n(o,l())end
local a=t[e()]if not a then
local e=u(k,1)n(c,e)end
repeat
n(o,l())a=t[e()]until not a
return o
end
local function E()local o={a}local r=false
local r=false
local r=false
if a=='0'and I[e()]then
return i(f(o))end
while t[e()]do
n(o,l())end
if e()=="."then
o=T(o)end
local e=e()if _[e]then
o=P(o)end
return i(o)end
local function f()local o,n={},0
local r
repeat
n=n+1
o[n]=a
local e=e()until not(U[e]and l())return i(o)end
local function T()if F(a)then
local e=E()return O(e,o)end
local e=u(V:format(a))n(c,e)return
end
local function i()local n=p
local r=r
local a=o
local e
local o=0
while true do
local a=r[a+o]n=n[a]if not n then break end
e=n.value
o=o+1
end
if not e then return end
l(#e-1)return e
end
local function t()local e=a
if Y[e]then
return
elseif N[e]then
return y(e,o)elseif R[e]then
return L(f(),o)elseif e==","then
return v(o)else
local e=i()if e then
return g(e,o)end
return T()end
end
local function i()local n,e={},0
local o=a
while o~="\0"do
local a=t()if a then
e=e+1
n[e]=a
end
o=l()end
return n
end
local function l(e,n)if e then
e=e
r=d[e]or b(e)a=r[1]o=1
d[e]=r
end
p=(n and h(n))or m
S=n or s
end
local function n()assert(r,x)c={}local e=i()C()return e
end
return{resetToInitialState=l,run=n}end
return C end)c['Lexer/TokenFactory']=(function(...)local e={}function e.createConstantToken(n,e)return{TYPE="Constant",Value=n,Position=e}end
function e.createVariableToken(e,n)return{TYPE="Variable",Value=e,Position=n}end
function e.createParenthesesToken(e,n)return{TYPE="Parentheses",Value=e,Position=n}end
function e.createOperatorToken(e,n)return{TYPE="Operator",Value=e,Position=n}end
function e.createCommaToken(e)return{TYPE="Comma",Value=",",Position=e}end
return e end)c['Parser/Parser']=(function(...)local n=t("Helpers/Helpers")local e=t("Parser/NodeFactory")local s=n.stringToTable
local T=table.insert
local n=table.concat
local S=math.max
local m=math.min
local d=string.rep
local R=e.createUnaryOperatorNode
local Y=e.createOperatorNode
local y=e.createFunctionCallNode
local t=20
local x="No tokens given"local k="No tokens to parse"local O="Expected EOF, got '%s'"local F="Unexpected token: '%s' in <primary>, expected constant, variable or function call"local c="Expected expression, got EOF"local f="Expected ')', got EOF"local L="Expected ',' or ')', got '%s'"local u="<No charStream, error message: %s>"local h={Unary={["-"]=7,["!"]=7,},Binary={[":="]=1,["&&"]=2,["||"]=3,["=="]=4,["!="]=4,[">"]=4,["<"]=4,[">="]=4,["<="]=4,["+"]=5,["-"]=5,["*"]=6,["/"]=6,["%"]=6,["^"]=7,},RightAssociativeBinaryOperators={["^"]=true},}local e={}local function V(l,o,n,a)local r,e
if l then
r=n or 1
e=l[r]end
local o=o or h
local i=a
local function p(e)return l[r+(e or 1)]end
local function n(n)local o=r+(n or 1)local n=l[o]r=o
e=n
return n
end
local function b(n)local e=n or e
if not o.Binary then return end
return e and e.TYPE=="Operator"and o.Binary[e.Value]end
local function P(n)local e=n or e
if not o.Unary then return end
return e and e.TYPE=="Operator"and o.Unary[e.Value]end
local function g(n)local e=n or e
if not o.RightAssociativeBinaryOperators then return end
return e and e.TYPE=="Operator"and o.RightAssociativeBinaryOperators[e.Value]end
local function E()local n=p()if not n then return end
return e.TYPE=="Variable"and n.TYPE=="Parentheses"and n.Value=="("end
local function v(e)return e and o.Binary[e.Value]end
local function a(o,...)if not i then
return u:format(o)end
local n=s(i)local a=o:format(...)local e=(not e and#n+1)or e.Position
local o={}for e=S(1,e-t),m(e+t,#n)do
T(o,n[e])end
local n=table.concat(o)local e=d(" ",e-1).."^"return"\n"..n.."\n"..e.."\n"..a
end
local s,d,u,m,t
function s()local l=e.Value
n(2)local o={}while true do
local r=t()T(o,r)if not e then
local e=p(-1)if e.TYPE=="Comma"then
error(a(c))end
error(a(f))elseif e.Value==")"then
break
elseif e.TYPE=="Comma"then
n()else
error(a(L,e.Value))end
end
n()return y(l,o)end
function d(l)local o=u()while b(e)do
local r=v(e)if r<=l and not g(e)then
break
end
local l=e
if not n()then
error(a(c))end
local e=d(r)o=Y(l.Value,o,e)end
return o
end
function u()if not P(e)then
return m()end
local e=e.Value
if not n()then
error(a(c))end
local n=u()return R(e,n)end
function m()local o=e
if not o then return end
local l=o.Value
local r=o.TYPE
if r=="Parentheses"and l=="("then
n()local o=t()if not e or e.Value~=")"then
error(a(f))end
n()return o
elseif r=="Variable"then
if E()then
return s()end
n()return o
elseif r=="Constant"then
n()return o
end
error(a(F,l))end
function t()local e=d(0)return e
end
local function u(n,c,t,a)assert(n,x)l=n
r=t or 1
e=n[r]o=c or h
i=a
end
local function n(o)assert(l,k)local n=t()if e and not o then
error(a(O,e.Value))end
return n
end
return{resetToInitialState=u,parse=n}end
return V end)c['Parser/NodeFactory']=(function(...)local e={}function e.createUnaryOperatorNode(e,n)return{TYPE="UnaryOperator",Value=e,Operand=n}end
function e.createOperatorNode(n,e,o)return{TYPE="Operator",Value=n,Left=e,Right=o}end
function e.createFunctionCallNode(e,n)return{TYPE="FunctionCall",FunctionName=e,Arguments=n}end
return e end)c['MathParser']=(function(...)local e=t("Helpers/Helpers")local i=t("Evaluator/Evaluator")local u=t("Lexer/Lexer")local c=t("Parser/Parser")local e={}function e:tokenize(e)if self.cachedTokens[e]then
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
function e:addVariable(n,e)self.variables=self.variables or{}self.variables[n]=e
self.cachedResults={}end
function e:addVariables(e)for e,n in pairs(e)do
self:addVariable(e,n)end
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
function e:resetToInitialState(n,e,o,a,r)self.operatorPrecedenceLevels=n
self.variables=e
self.operatorFunctions=o
self.operators=a
self.functions=r
self.cachedTokens={}self.cachedASTs={}self.cachedResults={}end
local r={}function r:new(a,o,l,r,t)local n={}for e,a in pairs(e)do
n[e]=a
end
o=o or{}o['false']=false
o['true']=true
n.operatorPrecedenceLevels=a
n.variables=o
n.operatorFunctions=l
n.operators=r
n.functions=t
n.cachedTokens={}n.cachedASTs={}n.cachedResults={}n.Lexer=u(nil,r)n.Parser=c(nil,a)n.Evaluator=i(nil,o,l,t)return n
end
return r end)local n,e="LibFormula-1.0",1
local n,e=LibStub and LibStub:NewLibrary(n,e)or{}if not n then return end
local e={}function n:CreateInstance()return e:new()end
local o=t('MathParser')function e:new()return setmetatable({__vm=o:new()},{__index=self})end
function e:addFunc(n,e)assert(self.__vm,'Invalid instance object')self.__vm:addFunction(n,e)end
function e:exec(e)assert(self.__vm,'Invalid instance object')return self.__vm:solve(e)end
return n
