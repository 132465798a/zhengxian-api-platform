import{E as e,b as t,et as n,mt as r,tr as i,xt as a}from"./runtime-core.esm-bundler-D1Q-n0wH.js";import{t as o}from"./style-eusJYGtA.js";import{A as s,T as c}from"./dist-cVYoUjJh.js";import{t as l}from"./classnames-CRHlWn3X.js";import{t as u}from"./basecomponent-C4Qtoha1.js";var d=o.extend({name:`badge`,style:`
    .p-badge {
        display: inline-flex;
        border-radius: dt('badge.border.radius');
        align-items: center;
        justify-content: center;
        padding: dt('badge.padding');
        background: dt('badge.primary.background');
        color: dt('badge.primary.color');
        font-size: dt('badge.font.size');
        font-weight: dt('badge.font.weight');
        min-width: dt('badge.min.width');
        height: dt('badge.height');
    }

    .p-badge-dot {
        width: dt('badge.dot.size');
        min-width: dt('badge.dot.size');
        height: dt('badge.dot.size');
        border-radius: 50%;
        padding: 0;
    }

    .p-badge-circle {
        padding: 0;
        border-radius: 50%;
    }

    .p-badge-secondary {
        background: dt('badge.secondary.background');
        color: dt('badge.secondary.color');
    }

    .p-badge-success {
        background: dt('badge.success.background');
        color: dt('badge.success.color');
    }

    .p-badge-info {
        background: dt('badge.info.background');
        color: dt('badge.info.color');
    }

    .p-badge-warn {
        background: dt('badge.warn.background');
        color: dt('badge.warn.color');
    }

    .p-badge-danger {
        background: dt('badge.danger.background');
        color: dt('badge.danger.color');
    }

    .p-badge-contrast {
        background: dt('badge.contrast.background');
        color: dt('badge.contrast.color');
    }

    .p-badge-sm {
        font-size: dt('badge.sm.font.size');
        min-width: dt('badge.sm.min.width');
        height: dt('badge.sm.height');
    }

    .p-badge-lg {
        font-size: dt('badge.lg.font.size');
        min-width: dt('badge.lg.min.width');
        height: dt('badge.lg.height');
    }

    .p-badge-xl {
        font-size: dt('badge.xl.font.size');
        min-width: dt('badge.xl.min.width');
        height: dt('badge.xl.height');
    }
`,classes:{root:function(e){var t=e.props,n=e.instance;return[`p-badge p-component`,{"p-badge-circle":s(t.value)&&String(t.value).length===1,"p-badge-dot":c(t.value)&&!n.$slots.default,"p-badge-sm":t.size===`small`,"p-badge-lg":t.size===`large`,"p-badge-xl":t.size===`xlarge`,"p-badge-info":t.severity===`info`,"p-badge-success":t.severity===`success`,"p-badge-warn":t.severity===`warn`,"p-badge-danger":t.severity===`danger`,"p-badge-secondary":t.severity===`secondary`,"p-badge-contrast":t.severity===`contrast`}]}}}),f={name:`BaseBadge`,extends:u,props:{value:{type:[String,Number],default:null},severity:{type:String,default:null},size:{type:String,default:null}},style:d,provide:function(){return{$pcBadge:this,$parentInstance:this}}};function p(e){"@babel/helpers - typeof";return p=typeof Symbol==`function`&&typeof Symbol.iterator==`symbol`?function(e){return typeof e}:function(e){return e&&typeof Symbol==`function`&&e.constructor===Symbol&&e!==Symbol.prototype?`symbol`:typeof e},p(e)}function m(e,t,n){return(t=h(t))in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function h(e){var t=g(e,`string`);return p(t)==`symbol`?t:t+``}function g(e,t){if(p(e)!=`object`||!e)return e;var n=e[Symbol.toPrimitive];if(n!==void 0){var r=n.call(e,t);if(p(r)!=`object`)return r;throw TypeError(`@@toPrimitive must return a primitive value.`)}return(t===`string`?String:Number)(e)}var _={name:`Badge`,extends:f,inheritAttrs:!1,computed:{dataP:function(){return l(m(m({circle:this.value!=null&&String(this.value).length===1,empty:this.value==null&&!this.$slots.default},this.severity,this.severity),this.size,this.size))}}},v=[`data-p`];function y(o,s,c,l,u,d){return r(),t(`span`,n({class:o.cx(`root`),"data-p":d.dataP},o.ptmi(`root`)),[a(o.$slots,`default`,{},function(){return[e(i(o.value),1)]})],16,v)}_.render=y;export{_ as t};