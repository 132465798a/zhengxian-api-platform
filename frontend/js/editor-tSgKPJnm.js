const __vite__mapDeps=(i,m=__vite__mapDeps,d=(m.f||(m.f=["js/draft-storage-BR-MSYgS.js","js/rolldown-runtime-CNC7AqOf.js","js/asyncToGenerator-C83J4upk.js"])))=>i.map(i=>d[i]);
import{r as e}from"./rolldown-runtime-CNC7AqOf.js";import{D as t,E as n,Ht as r,On as i,St as a,Yt as o,Zn as s,_ as c,b as l,bt as u,ct as d,et as f,fn as p,g as m,it as h,k as g,mt as _,o as v,qt as y,tr as b,tt as x,un as S,v as C,vn as w,wt as T,xt as E,y as D}from"./runtime-core.esm-bundler-D1Q-n0wH.js";import{S as O}from"./runtime-dom.esm-bundler-CfoHtbR6.js";import{t as k}from"./locales-J2ce5-14.js";import{n as A,t as j}from"./objectSpread2-BzTFKcvP.js";import{n as M,t as N}from"./asyncToGenerator-C83J4upk.js";import{qt as ee}from"./use-auth-session-B7cWSSTl.js";import{n as te}from"./form-DJko3dpl.js";import{t as P}from"./preload-helper-DaercurD.js";import{t as F}from"./_plugin-vue_export-helper-BDNMzG2s.js";import{K as I,O as L,t as R}from"./style-eusJYGtA.js";import{S as z}from"./dist-cVYoUjJh.js";import{t as B}from"./classnames-CRHlWn3X.js";import{t as V}from"./basecomponent-C4Qtoha1.js";import{a as H}from"./feedback-BsmiwBuT.js";import{t as U}from"./button-DP3fpId9.js";import{t as W}from"./drawer-Fr_D21g6.js";import{t as G}from"./monaco-sql-input-CnXG99KL.js";import{_ as K,n as ne,p as q,v as re}from"./sql-api-CvTXc2MN.js";import{t as ie}from"./StepAdvancedPanel-fKD4rXL4.js";import{t as ae}from"./StepParamPanel-DEDDB5Oz.js";import{t as oe}from"./StepSqlPanel-CL5t66qZ.js";import{i as se}from"./sql-datasource-f92HBqKd.js";var ce=R.extend({name:`stepper`,style:`
    .p-steplist {
        position: relative;
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin: 0;
        padding: 0;
        list-style-type: none;
        overflow-x: auto;
    }

    .p-step {
        position: relative;
        display: flex;
        flex: 1 1 auto;
        align-items: center;
        gap: dt('stepper.step.gap');
        padding: dt('stepper.step.padding');
    }

    .p-step:last-of-type {
        flex: initial;
    }

    .p-step-header {
        border: 0 none;
        display: inline-flex;
        align-items: center;
        text-decoration: none;
        cursor: pointer;
        transition:
            background dt('stepper.transition.duration'),
            color dt('stepper.transition.duration'),
            border-color dt('stepper.transition.duration'),
            outline-color dt('stepper.transition.duration'),
            box-shadow dt('stepper.transition.duration');
        border-radius: dt('stepper.step.header.border.radius');
        outline-color: transparent;
        background: transparent;
        padding: dt('stepper.step.header.padding');
        gap: dt('stepper.step.header.gap');
    }

    .p-step-header:focus-visible {
        box-shadow: dt('stepper.step.header.focus.ring.shadow');
        outline: dt('stepper.step.header.focus.ring.width') dt('stepper.step.header.focus.ring.style') dt('stepper.step.header.focus.ring.color');
        outline-offset: dt('stepper.step.header.focus.ring.offset');
    }

    .p-stepper.p-stepper-readonly .p-step {
        cursor: auto;
    }

    .p-step-title {
        display: block;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        max-width: 100%;
        color: dt('stepper.step.title.color');
        font-weight: dt('stepper.step.title.font.weight');
        transition:
            background dt('stepper.transition.duration'),
            color dt('stepper.transition.duration'),
            border-color dt('stepper.transition.duration'),
            box-shadow dt('stepper.transition.duration'),
            outline-color dt('stepper.transition.duration');
    }

    .p-step-number {
        display: flex;
        align-items: center;
        justify-content: center;
        color: dt('stepper.step.number.color');
        border: 2px solid dt('stepper.step.number.border.color');
        background: dt('stepper.step.number.background');
        min-width: dt('stepper.step.number.size');
        height: dt('stepper.step.number.size');
        line-height: dt('stepper.step.number.size');
        font-size: dt('stepper.step.number.font.size');
        z-index: 1;
        border-radius: dt('stepper.step.number.border.radius');
        position: relative;
        font-weight: dt('stepper.step.number.font.weight');
    }

    .p-step-number::after {
        content: ' ';
        position: absolute;
        width: 100%;
        height: 100%;
        border-radius: dt('stepper.step.number.border.radius');
        box-shadow: dt('stepper.step.number.shadow');
    }

    .p-step-active .p-step-header {
        cursor: default;
    }

    .p-step-active .p-step-number {
        background: dt('stepper.step.number.active.background');
        border-color: dt('stepper.step.number.active.border.color');
        color: dt('stepper.step.number.active.color');
    }

    .p-step-active .p-step-title {
        color: dt('stepper.step.title.active.color');
    }

    .p-step:not(.p-disabled):focus-visible {
        outline: dt('focus.ring.width') dt('focus.ring.style') dt('focus.ring.color');
        outline-offset: dt('focus.ring.offset');
    }

    .p-step:has(~ .p-step-active) .p-stepper-separator {
        background: dt('stepper.separator.active.background');
    }

    .p-stepper-separator {
        flex: 1 1 0;
        background: dt('stepper.separator.background');
        width: 100%;
        height: dt('stepper.separator.size');
        transition:
            background dt('stepper.transition.duration'),
            color dt('stepper.transition.duration'),
            border-color dt('stepper.transition.duration'),
            box-shadow dt('stepper.transition.duration'),
            outline-color dt('stepper.transition.duration');
    }

    .p-steppanels {
        padding: dt('stepper.steppanels.padding');
    }

    .p-steppanel {
        background: dt('stepper.steppanel.background');
        color: dt('stepper.steppanel.color');
    }

    .p-stepper:has(.p-stepitem) {
        display: flex;
        flex-direction: column;
    }

    .p-stepitem {
        display: flex;
        flex-direction: column;
        flex: initial;
    }

    .p-stepitem.p-stepitem-active {
        flex: 1 1 auto;
    }

    .p-stepitem .p-step {
        flex: initial;
    }
    
    .p-stepitem .p-steppanel {
        display: grid;
        grid-template-rows: 1fr;
    }

    .p-stepitem .p-steppanel-content-wrapper {
        display: flex;
        flex: 1 1 auto;
        min-height: 0;
    }
    .p-stepitem .p-steppanel-content {
        width: 100%;
        padding: dt('stepper.steppanel.padding');
        margin-inline-start: 1rem;
    }

    .p-stepitem .p-stepper-separator {
        flex: 0 0 auto;
        width: dt('stepper.separator.size');
        height: auto;
        margin: dt('stepper.separator.margin');
        position: relative;
        left: calc(-1 * dt('stepper.separator.size'));
    }

    .p-stepitem .p-stepper-separator:dir(rtl) {
        left: calc(-9 * dt('stepper.separator.size'));
    }

    .p-stepitem:has(~ .p-stepitem-active) .p-stepper-separator {
        background: dt('stepper.separator.active.background');
    }

    .p-stepitem:last-of-type .p-steppanel {
        padding-inline-start: dt('stepper.step.number.size');
    }
`,classes:{root:function(e){return[`p-stepper p-component`,{"p-readonly":e.props.linear}]},separator:`p-stepper-separator`}}),le={name:`Stepper`,extends:{name:`BaseStepper`,extends:V,props:{value:{type:[String,Number],default:void 0},linear:{type:Boolean,default:!1}},style:ce,provide:function(){return{$pcStepper:this,$parentInstance:this,$pcStepItem:null}}},inheritAttrs:!1,emits:[`update:value`],data:function(){return{d_value:this.value}},watch:{value:function(e){this.d_value=e}},methods:{updateValue:function(e){this.d_value!==e&&(this.d_value=e,this.$emit(`update:value`,e))},isStepActive:function(e){return this.d_value===e},isStepDisabled:function(){return this.linear}}};function ue(e,t,n,r,i,a){return _(),l(`div`,f({class:e.cx(`root`),role:`tablist`},e.ptmi(`root`)),[e.$slots.start?E(e.$slots,`start`,{key:0}):D(``,!0),E(e.$slots,`default`),e.$slots.end?E(e.$slots,`end`,{key:1}):D(``,!0)],16)}le.render=ue;var J=R.extend({name:`step`,classes:{root:function(e){var t=e.instance;return[`p-step`,{"p-step-active":t.active,"p-disabled":t.isStepDisabled}]},header:`p-step-header`,number:`p-step-number`,title:`p-step-title`}}),Y={name:`StepperSeparator`,hostName:`Stepper`,extends:V,inject:{$pcStepper:{default:null}}};function X(e,t,n,r,i,a){return _(),l(`span`,f({class:e.cx(`separator`)},e.ptmo(a.$pcStepper.pt,`separator`)),null,16)}Y.render=X;var de={name:`Step`,extends:{name:`BaseStep`,extends:V,props:{value:{type:[String,Number],default:void 0},disabled:{type:Boolean,default:!1},asChild:{type:Boolean,default:!1},as:{type:[String,Object],default:`DIV`}},style:J,provide:function(){return{$pcStep:this,$parentInstance:this}}},inheritAttrs:!1,inject:{$pcStepper:{default:null},$pcStepList:{default:null},$pcStepItem:{default:null}},data:function(){return{isSeparatorVisible:!1,isCompleted:!1}},mounted:function(){this.updateState()},updated:function(){this.updateState()},methods:{updateState:function(){if(this.$el&&this.$pcStepList){var e=z(this.$el,L(this.$pcStepper.$el,`[data-pc-name="step"]`)),t=z(I(this.$pcStepper.$el,`[data-pc-name="step"][data-p-active="true"]`),L(this.$pcStepper.$el,`[data-pc-name="step"]`)),n=L(this.$pcStepper.$el,`[data-pc-name="step"]`).length;this.isSeparatorVisible=e!==n-1,this.isCompleted=e<t}},getPTOptions:function(e){return(e===`root`?this.ptmi:this.ptm)(e,{context:{active:this.active,disabled:this.isStepDisabled}})},onStepClick:function(){this.$pcStepper.updateValue(this.activeValue)}},computed:{active:function(){return this.$pcStepper.isStepActive(this.activeValue)},activeValue:function(){var e;return this.$pcStepItem?(e=this.$pcStepItem)==null?void 0:e.value:this.value},isStepDisabled:function(){return!this.active&&(this.$pcStepper.isStepDisabled()||this.disabled)},id:function(){var e;return`${(e=this.$pcStepper)==null?void 0:e.$id}_step_${this.activeValue}`},ariaControls:function(){var e;return`${(e=this.$pcStepper)==null?void 0:e.$id}_steppanel_${this.activeValue}`},a11yAttrs:function(){return{root:{role:`presentation`,"aria-current":this.active?`step`:void 0,"data-pc-name":`step`,"data-pc-section":`root`,"data-p-disabled":this.isStepDisabled,"data-p-active":this.active},header:{id:this.id,role:`tab`,taindex:this.disabled?-1:void 0,"aria-controls":this.ariaControls,"data-pc-section":`header`,disabled:this.isStepDisabled,onClick:this.onStepClick}}},dataP:function(){return B({disabled:this.isStepDisabled,readonly:this.$pcStepper.linear,active:this.active,completed:this.isCompleted,vertical:this.$pcStepItem!=null})}},components:{StepperSeparator:Y}},fe=[`id`,`tabindex`,`aria-controls`,`disabled`,`data-p`],pe=[`data-p`],me=[`data-p`];function Z(e,t,n,r,i,o){var l=a(`StepperSeparator`);return e.asChild?E(e.$slots,`default`,{key:1,class:s(e.cx(`root`)),active:o.active,value:e.value,a11yAttrs:o.a11yAttrs,activateCallback:o.onStepClick}):(_(),C(T(e.as),f({key:0,class:e.cx(`root`),"aria-current":o.active?`step`:void 0,role:`presentation`,"data-p-active":o.active,"data-p-disabled":o.isStepDisabled,"data-p":o.dataP},o.getPTOptions(`root`)),{default:y(function(){return[c(`button`,f({id:o.id,class:e.cx(`header`),role:`tab`,type:`button`,tabindex:o.isStepDisabled?-1:void 0,"aria-controls":o.ariaControls,disabled:o.isStepDisabled,onClick:t[0]||(t[0]=function(){return o.onStepClick&&o.onStepClick.apply(o,arguments)}),"data-p":o.dataP},o.getPTOptions(`header`)),[c(`span`,f({class:e.cx(`number`),"data-p":o.dataP},o.getPTOptions(`number`)),b(o.activeValue),17,pe),c(`span`,f({class:e.cx(`title`),"data-p":o.dataP},o.getPTOptions(`title`)),[E(e.$slots,`default`)],16,me)],16,fe),i.isSeparatorVisible?(_(),C(l,{key:0,"data-p":o.dataP},null,8,[`data-p`])):D(``,!0)]}),_:3},16,[`class`,`aria-current`,`data-p-active`,`data-p-disabled`,`data-p`]))}de.render=Z;var he={name:`StepList`,extends:{name:`BaseStepList`,extends:V,style:R.extend({name:`steplist`,classes:{root:`p-steplist`}}),provide:function(){return{$pcStepList:this,$parentInstance:this}}},inheritAttrs:!1};function Q(e,t,n,r,i,a){return _(),l(`div`,f({class:e.cx(`root`)},e.ptmi(`root`)),[E(e.$slots,`default`)],16)}he.render=Q;function ge(e){let{cacheOn:t,datasourceOptions:n,onDatasourceChange:r}=e;return{commonConfig:{componentProps:{class:`w-full`}},layout:`horizontal`,schema:[{component:`Select`,componentProps:{onChange:r,options:n,placeholder:k(`provider-view.sqleditor.form.placeholder.datasource`)},fieldName:`datasourceId`,label:k(`provider-view.sqleditor.form.field.datasource`),rules:`selectRequired`},{component:p(G),description:k(`provider-view.sqleditor.form.sql.description`),fieldName:`sqlText`,label:k(`provider-view.sqleditor.form.field.sqlText`),rules:`required`},{component:`RadioGroup`,componentProps:{buttonStyle:`solid`,optionType:`button`,options:[{label:k(`provider-view.sqleditor.form.resultType.list`),value:`LIST`},{label:k(`provider-view.sqleditor.form.resultType.object`),value:`OBJECT`}]},defaultValue:`LIST`,fieldName:`resultType`,label:k(`provider-view.sqleditor.form.field.resultType`)},{component:`InputNumber`,componentProps:{min:1,precision:0},defaultValue:1e3,fieldName:`maxRows`,label:k(`provider-view.sqleditor.form.field.maxRows`),rules:`required`},{component:`InputNumber`,componentProps:{min:1e3,precision:0,step:1e3},defaultValue:5e3,fieldName:`timeoutMs`,label:k(`provider-view.sqleditor.form.field.timeoutMs`),rules:`required`},{component:`RadioGroup`,componentProps:{buttonStyle:`solid`,optionType:`button`,options:[{label:k(`provider-view.sqleditor.form.cache.off`),value:`OFF`},{label:k(`provider-view.sqleditor.form.cache.on`),value:`ON`}],onChange:e=>{t.value=e===`ON`}},defaultValue:`OFF`,dependencies:{triggerFields:[`cacheSwitch`]},fieldName:`cacheSwitch`,label:k(`provider-view.sqleditor.form.field.cacheSwitch`)},{component:`InputNumber`,componentProps:{addonAfter:k(`provider-view.sqleditor.form.cache.ttlAddon`),min:1,precision:0},dependencies:{if:()=>t.value,triggerFields:[]},defaultValue:60,fieldName:`cacheTtlSeconds`,label:k(`provider-view.sqleditor.form.field.cacheTtlSeconds`)},{component:`Switch`,description:k(`provider-view.sqleditor.form.pageEnabled.description`),fieldName:`pageEnabled`,label:k(`provider-view.sqleditor.form.field.pageEnabled`)}],showDefaultActions:!1,wrapperClass:`grid-cols-1`}}function _e(e){let{categoryOptions:t}=e;return{commonConfig:{componentProps:{class:`w-full`}},layout:`horizontal`,schema:[{component:`Input`,fieldName:`name`,label:k(`provider-view.sqleditor.form.product.field.name`),rules:`required`},{component:`Select`,componentProps:{allowClear:!0,options:t},fieldName:`categoryId`,label:k(`provider-view.sqleditor.form.product.field.categoryId`)},{component:`Textarea`,componentProps:{maxlength:255,placeholder:k(`provider-view.sqleditor.form.product.placeholder.description`),rows:4,showCount:!0},fieldName:`description`,label:k(`provider-view.sqleditor.form.product.field.description`)},{component:`InputNumber`,componentProps:{min:0,precision:4},defaultValue:0,fieldName:`price`,label:k(`provider-view.sqleditor.form.product.field.price`),rules:`required`}],showDefaultActions:!1,wrapperClass:`grid-cols-1`}}M();function ve(e){return $.apply(this,arguments)}function $(){return $=N(function*(e){let t=yield q(e.sqlText,e.currentDbType,e.datasourceId),n=new Set(e.paramRows.map(e=>e.name.trim()).filter(Boolean)),r=0;for(let i of t.params)n.has(i)||(n.add(i),e.paramRows.push({defaultValue:``,desc:``,example:``,name:i,required:!t.conditionalParams.includes(i),type:`string`}),r+=1);return r>0?H.success(k(`provider-view.sqleditor.toast.paramsImported`,{count:r})):H.warning(k(`provider-view.sqleditor.toast.noNewParams`)),t}),$.apply(this,arguments)}function ye(e){let t={};for(let n of e.namedParamRows)t[n.name]=e.debugValues[n.name]||``;return K({datasourceId:e.datasourceId,fieldMapping:JSON.stringify(e.mappingRows),interfaceId:e.interfaceId,params:t,sqlText:e.sqlText})}function be(){return new Date().toISOString().slice(0,10)}function xe(e){var t,n;let r=((t=e.defaultValue)==null?``:t).trim()||((n=e.example)==null?``:n).trim();if(r)return r;if(e.type===`date`)return be();if(e.type===`number`)return`1`;let i=e.name.toLowerCase();return i.includes(`mobile`)||i.includes(`phone`)?`13800138000`:i.includes(`email`)?`test@example.com`:i.includes(`date`)||i.includes(`time`)?be():``}A();function Se(e,t){var n,r,i,a,o,s,c,l;t.paramRows.value=((n=e.params)==null?[]:n).map(e=>j({},e)),t.debugValues.value={};for(let e of t.paramRows.value)t.debugValues.value[e.name]=xe(e);t.debugResult.value=void 0,t.mappingRows.value=((r=e.fieldMapping)==null?[]:r).map(e=>j({},e)),t.resultColumns.value=[],t.cacheOn.value=Number(e.cacheEnabled)===1,t.currentDatasourceId.value=e.datasourceId,t.concurrencyLimit.value=Number(e.concurrencyLimit)||0,t.canaryOn.value=!!e.canaryEnabled,t.canaryPercent.value=Number(e.canaryPercent)||10,t.canaryDatasourceId.value=((i=e.canaryJson)==null?void 0:i.datasourceId)||void 0,t.canarySql.value=(a=(o=e.canaryJson)==null?void 0:o.sqlText)==null?``:a,t.mockOn.value=!!e.mockEnabled,t.mockJsonText.value=e.mockJson==null?``:JSON.stringify(e.mockJson,null,2),t.mockJsonError.value=``,t.fallbackOn.value=!!e.fallbackEnabled,t.fallbackJsonText.value=e.fallbackJson==null?``:JSON.stringify(e.fallbackJson,null,2),t.fallbackJsonError.value=``,t.fieldWhitelist.value=!!e.fieldWhitelist,t.scriptSteps.value=((s=(c=e.scriptJson)==null?void 0:c.steps)==null?[]:s).map(e=>j({},e)),t.dynamicRules.value=((l=e.dynamicDatasourceJson)==null?[]:l).map(e=>j({},e)),t.pricePerKrows.value=Number(e.pricePerKrows)||0}function Ce(e){let t=e.trim();return t?JSON.parse(t):void 0}function we(e){var t,n,r;let{baseValues:i,canaryDatasourceId:a,canaryOn:o,canaryPercent:s,canarySql:c,cacheOn:l,concurrencyLimit:u,dynamicRules:d,fallbackJsonText:f,fallbackOn:p,fieldWhitelist:m,mappingRows:h,mockJsonText:g,mockOn:_,paramRows:v,pricePerKrows:y,productValues:b,scriptSteps:x}=e,S=x.filter(e=>e.expression.trim()).map(e=>{var t;return{action:e.action,expression:e.expression.trim(),target:e.action===`compute`&&((t=e.target)==null?void 0:t.trim())||void 0}}),C=d.filter(e=>e.datasourceId&&e.expression.trim());return{cacheEnabled:l,cacheTtlSeconds:l?Number(i.cacheTtlSeconds)||60:0,canaryEnabled:o,canaryJson:o?{datasourceId:a||``,sqlText:c}:void 0,canaryPercent:o?s:void 0,categoryId:b.categoryId||void 0,concurrencyLimit:Number(u)||0,datasourceId:i.datasourceId,description:String((t=b.description)==null?``:t).trim()||void 0,dynamicDatasourceJson:C.length>0?C:null,fallbackEnabled:p,fallbackJson:p?Ce(f):void 0,fieldMapping:h.length>0?h:void 0,fieldWhitelist:m,maxRows:Number(i.maxRows)||1e3,mockEnabled:_,mockJson:_?Ce(g):void 0,name:String((n=b.name)==null?``:n).trim(),pageEnabled:i.pageEnabled==null?void 0:!!i.pageEnabled,params:v.map(e=>{var t,n,r,i,a;return{defaultValue:((t=e.defaultValue)==null?void 0:t.trim())||void 0,desc:((n=e.desc)==null?void 0:n.trim())||void 0,enumValues:(r=e.enumValues)!=null&&r.length?e.enumValues.slice(0,20):void 0,example:((i=e.example)==null?void 0:i.trim())||void 0,maxLength:(a=e.maxLength)==null?void 0:a,name:e.name.trim(),required:e.required,type:e.type}}),price:Number((r=b.price)==null?0:r),pricePerKrows:Number(y)||0,resultType:i.resultType,scriptJson:S.length>0?{steps:S}:null,sqlText:i.sqlText,timeoutMs:Number(i.timeoutMs)||5e3}}M(),A();function Te(e){let t=!1,n=!1,i=null;function a(){var t;return`sqlapi-editor-draft:${(t=e.editingId.value)==null?`new`:t}`}function o(){return s.apply(this,arguments)}function s(){return s=N(function*(){try{return yield(yield P(()=>import(`./draft-storage-BR-MSYgS.js`).then(e=>e.n),__vite__mapDeps([0,1,2]))).getDraft(a())}catch(e){return null}}),s.apply(this,arguments)}function c(e){return l.apply(this,arguments)}function l(){return l=N(function*(e){try{yield(yield P(()=>import(`./draft-storage-BR-MSYgS.js`).then(e=>e.n),__vite__mapDeps([0,1,2]))).setDraft(a(),j({savedAt:Date.now()},e)),t=!0}catch(e){}}),l.apply(this,arguments)}function u(){return f.apply(this,arguments)}function f(){return f=N(function*(){t=!1;try{yield(yield P(()=>import(`./draft-storage-BR-MSYgS.js`).then(e=>e.n),__vite__mapDeps([0,1,2]))).clearDraft(a())}catch(e){}}),f.apply(this,arguments)}function p(){return e.currentStep.value>0||e.paramRows.value.length>0}r([e.paramRows,e.scriptSteps],()=>{n||!p()||(i&&clearTimeout(i),i=setTimeout(()=>{N(function*(){var t;let n=yield e.getBaseValues(),r=yield e.getProductValues();yield c({baseValues:n,currentStep:e.currentStep.value,paramRows:e.paramRows.value,productValues:r,sqlText:String((t=n.sqlText)==null?``:t)})})()},800))},{deep:!0});function m(e){t&&e.preventDefault()}d(()=>{window.addEventListener(`beforeunload`,m)}),h(()=>{window.removeEventListener(`beforeunload`,m),i&&clearTimeout(i)});function g(){return n=!0,()=>{n=!1}}function _(e){return v.apply(this,arguments)}function v(){return v=N(function*(e){let t=yield o();if(!t||!t.savedAt||!t.sqlText&&!t.baseValues)return!1;let n=g();try{var r;t.baseValues&&e.setBaseValues(t.baseValues),(r=t.paramRows)!=null&&r.length&&e.setParamRows(t.paramRows),typeof t.currentStep==`number`&&e.setCurrentStep(t.currentStep),t.productValues&&e.setProductValues(t.productValues)}finally{n()}return!0}),v.apply(this,arguments)}return{beginRestore:g,clearSqlDraft:u,readSqlDraft:o,restoreDraft:_}}A(),M();function Ee(e){let t=w(),n=w(``),r=w(0),i=[{title:k(`provider-view.sqleditor.step.base`)},{title:k(`provider-view.sqleditor.step.params`)},{title:k(`provider-view.sqleditor.step.product`)}],a=m({get:()=>r.value+1,set:e=>{r.value=Math.min(Math.max(e-1,0),i.length-1)}}),o=w([]);se().then(e=>{o.value=e.filter(e=>Number(e.status)===1).map(e=>({dbType:e.dbType||`MYSQL`,label:`${e.name}（${e.host}:${e.port}/${e.databaseName}）`,value:e.id}))}).catch(()=>{o.value=[]});let s=w(`MYSQL`),c=w(),l=w(!0);function u(e){c.value=e;let t=o.value.find(t=>t.value===e);s.value=(t==null?void 0:t.dbType)||`MYSQL`}let d=w([]);ee().then(e=>{d.value=e.map(e=>({label:e.name,value:e.id}))}).catch(()=>{d.value=[]});let f=w(!1),p=w([]),h=w([]),[g,_]=te(ge({cacheOn:f,datasourceOptions:o,onDatasourceChange:u})),[v,y]=te(_e({categoryOptions:d})),b=w([]),S=w({}),C=w();function T(e){var t;let n=_.getFieldComponentRef(`sqlText`);n==null||(t=n.insertText)==null||t.call(n,e)}function E(e){var t;let n=_.getFieldComponentRef(`sqlText`);n==null||(t=n.setMetadata)==null||t.call(n,e)}function D(e){let t=(e==null?void 0:e.sqlText)||(e==null?void 0:e.sql);if(t&&_.setFieldValue(`sqlText`,t),e!=null&&e.resultType&&_.setFieldValue(`resultType`,e.resultType),e!=null&&e.params&&Array.isArray(e.params)){b.value=e.params.map(e=>{var t;return{defaultValue:e.defaultValue||``,desc:e.desc||``,example:e.example||``,name:e.name,required:(t=e.required)!=null&&t,type:e.type||`string`}});for(let e of b.value)S.value[e.name]=xe(e)}e!=null&&e.fieldMapping&&Array.isArray(e.fieldMapping)&&(p.value=e.fieldMapping.map(e=>j({},e))),e!=null&&e.resultColumns&&Array.isArray(e.resultColumns)&&(h.value=e.resultColumns)}let O=w(0),A=w(!1),M=w(10),P=w(),F=w(``),I=w(!1),L=w(``),R=w(``),z=w(!1),B=w(``),V=w(``),U=w(!1),W=w([]),G=w([]),K=w(0),q=w(!1),ie=w(!1),ae=w(!1),oe=w([]),ce=m(()=>b.value.filter(e=>e.name.trim())),{clearSqlDraft:le,restoreDraft:ue}=Te({currentStep:r,editingId:t,getBaseValues:function(){var e=N(function*(){return yield _.getValues()});return function(){return e.apply(this,arguments)}}(),getProductValues:function(){var e=N(function*(){return yield y.getValues()});return function(){return e.apply(this,arguments)}}(),paramRows:b,scriptSteps:W}),J=w(!1);function Y(e){return X.apply(this,arguments)}function X(){return X=N(function*(e){var i,a,l,u,d,m,g,v,w,T;t.value=e==null?void 0:e.id,n.value=(i=e==null?void 0:e.interfaceName)==null?``:i,r.value=(a=e==null?void 0:e.initialStep)==null?0:a,Se(e==null?{}:e,{canaryDatasourceId:P,canaryOn:A,canaryPercent:M,canarySql:F,cacheOn:f,concurrencyLimit:O,currentDatasourceId:c,debugResult:C,debugValues:S,dynamicRules:G,fallbackJsonError:V,fallbackJsonText:B,fallbackOn:z,fieldWhitelist:U,mappingRows:p,mockJsonError:R,mockJsonText:L,mockOn:I,paramRows:b,pricePerKrows:K,resultColumns:h,scriptSteps:W});let E=o.value.find(t=>t.value===(e==null?void 0:e.datasourceId));s.value=(E==null?void 0:E.dbType)||(e==null?void 0:e.dbType)||`MYSQL`,_.resetForm(),yield x(),_.setValues({cacheSwitch:f.value?`ON`:`OFF`,cacheTtlSeconds:(e==null?void 0:e.cacheTtlSeconds)||60,datasourceId:e==null?void 0:e.datasourceId,pageEnabled:(e==null?void 0:e.pageEnabled)==null?void 0:!!Number(e.pageEnabled),sqlText:(l=e==null?void 0:e.sqlText)==null?``:l,resultType:(u=e==null?void 0:e.resultType)==null?`LIST`:u,maxRows:(d=e==null?void 0:e.maxRows)==null?1e3:d,timeoutMs:(m=e==null?void 0:e.timeoutMs)==null?5e3:m}),y.resetForm(),yield x(),y.setValues({name:(g=e==null?void 0:e.interfaceName)==null?``:g,categoryId:(v=e==null?void 0:e.categoryId)==null?void 0:v,description:(w=e==null?void 0:e.description)==null?``:w,price:(T=e==null?void 0:e.price)==null?0:T}),e!=null&&e.id||(yield ue({setBaseValues:e=>_.setValues(e),setCurrentStep:e=>{r.value=e},setParamRows:e=>{b.value=e},setProductValues:e=>y.setValues(e)}))&&H.info(k(`provider-view.sqleditor.toast.draftRestored`)),J.value=!0}),X.apply(this,arguments)}let de=m(()=>t.value?k(`provider-view.sqleditor.editTitle`,{name:n.value||``}):k(`ui.actionTitle.create`,[k(`provider-view.sqleditor.title`)]));function fe(){if(b.value.some(e=>!e.name.trim()))return H.warning(k(`provider-view.sqleditor.toast.paramNameRequired`)),!1;let e=b.value.map(e=>e.name.trim());return new Set(e).size===e.length?!0:(H.warning(k(`provider-view.sqleditor.toast.paramNameDuplicated`)),!1)}function pe(){return me.apply(this,arguments)}function me(){return me=N(function*(){if(r.value===0){let{valid:e}=yield _.validate();if(!e)return}else if(r.value===1&&!fe())return;r.value+=1}),me.apply(this,arguments)}function Z(){--r.value}function he(){return Q.apply(this,arguments)}function Q(){return Q=N(function*(){let{valid:e}=yield _.validate();if(!e)return;let{sqlText:t}=yield _.getValues();q.value=!0;try{var n;let e=yield ve({currentDbType:s.value,datasourceId:c.value,paramRows:b.value,sqlText:t});h.value=e.resultColumns,oe.value=(n=e.conditionalParams)==null?[]:n}finally{q.value=!1}}),Q.apply(this,arguments)}function $(){return be.apply(this,arguments)}function be(){return be=N(function*(){let{valid:e}=yield _.validate();if(!e){r.value=0;return}let n=yield _.getValues();ie.value=!0;try{C.value=yield ye({datasourceId:n.datasourceId,debugValues:S.value,interfaceId:t.value,mappingRows:p.value,namedParamRows:ce.value,sqlText:n.sqlText})}finally{ie.value=!1}}),be.apply(this,arguments)}function Ce(){return Ee.apply(this,arguments)}function Ee(){return Ee=N(function*(){var n;let[i,a]=yield Promise.all([_.validate(),y.validate()]);if(!i.valid){r.value=0;return}if(!a.valid){r.value=2;return}if(!fe()){r.value=1;return}if((n=e.advancedPanelRef.value)==null||n.validateJson(),I.value&&R.value){r.value=1,H.warning(k(`provider-view.sqleditor.toast.mockInvalidJson`));return}if(z.value&&V.value){r.value=1,H.warning(k(`provider-view.sqleditor.toast.fallbackInvalidJson`));return}if(A.value&&!P.value){r.value=1,H.warning(k(`provider-view.sqleditor.toast.canaryDatasourceRequired`));return}let o=yield _.getValues(),s=yield y.getValues(),c=we({baseValues:o,canaryDatasourceId:P.value,canaryOn:A.value,canaryPercent:M.value,canarySql:F.value,cacheOn:f.value,concurrencyLimit:O.value,dynamicRules:G.value,fallbackJsonText:B.value,fallbackOn:z.value,fieldWhitelist:U.value,mappingRows:p.value,mockJsonText:L.value,mockOn:I.value,paramRows:b.value,pricePerKrows:K.value,productValues:s,scriptSteps:W.value});ae.value=!0;try{yield t.value?re(t.value,c):ne(c),le(),e.onSuccess(t.value?`update`:`create`),J.value=!1}catch(e){}finally{ae.value=!1}}),Ee.apply(this,arguments)}return{BaseForm:g,ProductForm:v,canaryDatasourceId:P,canaryOn:A,canaryPercent:M,canarySql:F,concurrencyLimit:O,conditionalParams:oe,currentDatasourceId:c,currentStep:r,datasourceOptions:o,debugResult:C,debugValues:S,drawerTitle:de,dynamicRules:G,fallbackJsonError:V,fallbackJsonText:B,fallbackOn:z,fieldWhitelist:U,mappingRows:p,mockJsonError:R,mockJsonText:L,mockOn:I,namedParamRows:ce,nextStep:pe,onGeneratedFromTree:D,onInsertFromTree:T,onMetadataFromTree:E,onParseParams:he,onSave:Ce,onTest:$,open:Y,paramRows:b,parsing:q,prevStep:Z,pricePerKrows:K,resultColumns:h,saving:ae,scriptSteps:W,stepItems:i,stepperModel:a,testing:ie,treeVisible:l,visible:J}}var De={class:`min-w-0`},Oe={class:`truncate text-[15px] leading-none font-medium tracking-tight`},ke={class:`text-muted-foreground mt-1.5 text-[12px] leading-none`},Ae={class:`flex h-full min-h-0 flex-col`},je={class:`flex min-h-0 flex-1 flex-col overflow-y-auto pr-1`},Me={class:`text-sm font-normal`},Ne={class:`flex-1 min-h-0`},Pe={class:`rounded border border-border bg-card p-4`},Fe={class:`mt-3 flex shrink-0 items-center justify-between gap-2 border-t border-border pt-3`},Ie={class:`text-muted-foreground text-[12px] leading-none`},Le={class:`flex gap-2`},Re={key:0,class:`i-mingcute-loading-3-line animate-spin`},ze=g({__name:`editor`,emits:[`success`],setup(e,{expose:r,emit:a}){let s=a,d=w(),{BaseForm:f,ProductForm:p,canaryDatasourceId:m,canaryOn:h,canaryPercent:g,canarySql:x,concurrencyLimit:T,conditionalParams:E,currentDatasourceId:A,currentStep:j,datasourceOptions:M,debugResult:N,debugValues:ee,drawerTitle:te,dynamicRules:P,fallbackJsonError:F,fallbackJsonText:I,fallbackOn:L,fieldWhitelist:R,mappingRows:z,mockJsonError:B,mockJsonText:V,mockOn:H,namedParamRows:G,nextStep:K,onGeneratedFromTree:ne,onInsertFromTree:q,onMetadataFromTree:re,onParseParams:se,onSave:ce,onTest:ue,open:J,paramRows:Y,parsing:X,prevStep:fe,pricePerKrows:pe,resultColumns:me,saving:Z,scriptSteps:Q,stepItems:ge,stepperModel:_e,testing:ve,treeVisible:$,visible:ye}=Ee({advancedPanelRef:d,onSuccess:e=>s(`success`,{mode:e})});return r({open:J}),(e,r)=>(_(),C(i(W),{visible:i(ye),"onUpdate:visible":r[22]||(r[22]=e=>S(ye)?ye.value=e:null),class:`sql-editor-drawer`,style:{width:`min(1080px, 92vw)`},position:`right`},{header:y(()=>[c(`div`,De,[c(`div`,Oe,b(i(te)),1),c(`div`,ke,b(i(k)(`provider-view.sqleditor.intro`)),1)])]),default:y(()=>{var e;return[c(`div`,Ae,[c(`div`,je,[t(i(le),{value:i(_e),"onUpdate:value":r[0]||(r[0]=e=>S(_e)?_e.value=e:null),class:`sql-editor-stepper pointer-events-none mb-6`},{default:y(()=>[t(i(he),null,{default:y(()=>[(_(!0),l(v,null,u(i(ge),(e,t)=>(_(),C(i(de),{key:e.title,value:t+1},{default:y(()=>[c(`span`,Me,b(e.title),1)]),_:2},1032,[`value`]))),128))]),_:1})]),_:1},8,[`value`]),o(c(`div`,Ne,[t(oe,{"datasource-id":i(A),parsing:i(X),"tree-visible":i($),onCollapse:r[1]||(r[1]=e=>$.value=!1),onExpand:r[2]||(r[2]=e=>$.value=!0),onGenerated:i(ne),onInsert:i(q),onMetadata:i(re),onParse:i(se)},{default:y(()=>[t(i(f))]),_:1},8,[`datasource-id`,`parsing`,`tree-visible`,`onGenerated`,`onInsert`,`onMetadata`,`onParse`])],512),[[O,i(j)===0]]),o(c(`div`,null,[t(ae,{"debug-values":i(ee),"onUpdate:debugValues":r[3]||(r[3]=e=>S(ee)?ee.value=e:null),"mapping-rows":i(z),"onUpdate:mappingRows":r[4]||(r[4]=e=>S(z)?z.value=e:null),"param-rows":i(Y),"onUpdate:paramRows":r[5]||(r[5]=e=>S(Y)?Y.value=e:null),"conditional-params":i(E),"debug-result":i(N),"named-param-rows":i(G),"result-columns":i(me),testing:i(ve),onTest:i(ue)},null,8,[`debug-values`,`mapping-rows`,`param-rows`,`conditional-params`,`debug-result`,`named-param-rows`,`result-columns`,`testing`,`onTest`]),t(ie,{ref_key:`advancedPanelRef`,ref:d,"canary-datasource-id":i(m),"onUpdate:canaryDatasourceId":r[6]||(r[6]=e=>S(m)?m.value=e:null),"canary-on":i(h),"onUpdate:canaryOn":r[7]||(r[7]=e=>S(h)?h.value=e:null),"canary-percent":i(g),"onUpdate:canaryPercent":r[8]||(r[8]=e=>S(g)?g.value=e:null),"canary-sql":i(x),"onUpdate:canarySql":r[9]||(r[9]=e=>S(x)?x.value=e:null),"concurrency-limit":i(T),"onUpdate:concurrencyLimit":r[10]||(r[10]=e=>S(T)?T.value=e:null),"dynamic-rules":i(P),"onUpdate:dynamicRules":r[11]||(r[11]=e=>S(P)?P.value=e:null),"fallback-json-error":i(F),"onUpdate:fallbackJsonError":r[12]||(r[12]=e=>S(F)?F.value=e:null),"fallback-json-text":i(I),"onUpdate:fallbackJsonText":r[13]||(r[13]=e=>S(I)?I.value=e:null),"fallback-on":i(L),"onUpdate:fallbackOn":r[14]||(r[14]=e=>S(L)?L.value=e:null),"field-whitelist":i(R),"onUpdate:fieldWhitelist":r[15]||(r[15]=e=>S(R)?R.value=e:null),"mock-json-error":i(B),"onUpdate:mockJsonError":r[16]||(r[16]=e=>S(B)?B.value=e:null),"mock-json-text":i(V),"onUpdate:mockJsonText":r[17]||(r[17]=e=>S(V)?V.value=e:null),"mock-on":i(H),"onUpdate:mockOn":r[18]||(r[18]=e=>S(H)?H.value=e:null),"price-per-krows":i(pe),"onUpdate:pricePerKrows":r[19]||(r[19]=e=>S(pe)?pe.value=e:null),"script-steps":i(Q),"onUpdate:scriptSteps":r[20]||(r[20]=e=>S(Q)?Q.value=e:null),"datasource-options":i(M)},null,8,[`canary-datasource-id`,`canary-on`,`canary-percent`,`canary-sql`,`concurrency-limit`,`dynamic-rules`,`fallback-json-error`,`fallback-json-text`,`fallback-on`,`field-whitelist`,`mock-json-error`,`mock-json-text`,`mock-on`,`price-per-krows`,`script-steps`,`datasource-options`])],512),[[O,i(j)===1]]),o(c(`div`,Pe,[t(i(p))],512),[[O,i(j)===2]])]),c(`div`,Fe,[c(`span`,Ie,b(i(k)(`provider-view.sqleditor.stepIndicator`,{current:i(j)+1,title:(e=i(ge)[i(j)])==null?void 0:e.title,total:i(ge).length})),1),c(`div`,Le,[t(i(U),{outlined:``,severity:`secondary`,disabled:i(Z),onClick:r[21]||(r[21]=e=>ye.value=!1)},{default:y(()=>[n(b(i(k)(`common.cancel`)),1)]),_:1},8,[`disabled`]),i(j)>0?(_(),C(i(U),{key:0,variant:`outline`,disabled:i(Z),onClick:i(fe)},{default:y(()=>[n(b(i(k)(`provider-view.sqleditor.prevStep`)),1)]),_:1},8,[`disabled`,`onClick`])):D(``,!0),i(j)<2?(_(),C(i(U),{key:1,onClick:i(K)},{default:y(()=>[n(b(i(k)(`provider-view.sqleditor.nextStep`)),1)]),_:1},8,[`onClick`])):(_(),C(i(U),{key:2,disabled:i(Z),onClick:i(ce)},{default:y(()=>[i(Z)?(_(),l(`span`,Re)):D(``,!0),n(` `+b(i(k)(`common.save`)),1)]),_:1},8,[`disabled`,`onClick`]))])])])]}),_:1},8,[`visible`]))}}),Be=e({default:()=>Ve}),Ve=F(ze,[[`__scopeId`,`data-v-60bec6f8`]]);export{Be as n,Ve as t};