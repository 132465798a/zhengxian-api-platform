import{Ct as e,D as t,St as n,Yt as r,b as i,et as a,mt as o,qt as s,v as c,xt as l,y as u}from"./runtime-core.esm-bundler-D1Q-n0wH.js";import{t as d}from"./runtime-dom.esm-bundler-CfoHtbR6.js";import{A as f,E as p,N as m,U as h,k as g,o as _,p as v,t as y,x as b}from"./style-eusJYGtA.js";import{s as x}from"./dist-cVYoUjJh.js";import{t as S}from"./zindex-cO8iUN-n.js";import{t as C}from"./utils-ry0e3Lut.js";import{t as w}from"./basecomponent-C4Qtoha1.js";import{t as T}from"./overlayeventbus-0BhTUU3W.js";import{t as E}from"./portal-BwSz8ulm.js";import{t as D}from"./ripple-BVBnaH0F.js";import{t as O}from"./focustrap-Bd-2ejJA.js";var k=y.extend({name:`popover`,style:`
    .p-popover {
        margin-block-start: dt('popover.gutter');
        background: dt('popover.background');
        color: dt('popover.color');
        border: 1px solid dt('popover.border.color');
        border-radius: dt('popover.border.radius');
        box-shadow: dt('popover.shadow');
        will-change: transform;
    }

    .p-popover-content {
        padding: dt('popover.content.padding');
    }

    .p-popover-flipped {
        margin-block-start: calc(dt('popover.gutter') * -1);
        margin-block-end: dt('popover.gutter');
    }

    .p-popover:after,
    .p-popover:before {
        bottom: 100%;
        left: calc(dt('popover.arrow.offset') + dt('popover.arrow.left'));
        content: ' ';
        height: 0;
        width: 0;
        position: absolute;
        pointer-events: none;
    }

    .p-popover:after {
        border-width: calc(dt('popover.gutter') - 2px);
        margin-left: calc(-1 * (dt('popover.gutter') - 2px));
        border-style: solid;
        border-color: transparent;
        border-bottom-color: dt('popover.background');
    }

    .p-popover:before {
        border-width: dt('popover.gutter');
        margin-left: calc(-1 * dt('popover.gutter'));
        border-style: solid;
        border-color: transparent;
        border-bottom-color: dt('popover.border.color');
    }

    .p-popover-flipped:after,
    .p-popover-flipped:before {
        bottom: auto;
        top: 100%;
    }

    .p-popover.p-popover-flipped:after {
        border-bottom-color: transparent;
        border-top-color: dt('popover.background');
    }

    .p-popover.p-popover-flipped:before {
        border-bottom-color: transparent;
        border-top-color: dt('popover.border.color');
    }
`,classes:{root:`p-popover p-component`,content:`p-popover-content`}}),A={name:`Popover`,extends:{name:`BasePopover`,extends:w,props:{dismissable:{type:Boolean,default:!0},appendTo:{type:[String,Object],default:`body`},baseZIndex:{type:Number,default:0},autoZIndex:{type:Boolean,default:!0},breakpoints:{type:Object,default:null},closeOnEscape:{type:Boolean,default:!0}},style:k,provide:function(){return{$pcPopover:this,$parentInstance:this}}},inheritAttrs:!1,emits:[`show`,`hide`],data:function(){return{visible:!1}},watch:{dismissable:{immediate:!0,handler:function(e){e?this.bindOutsideClickListener():this.unbindOutsideClickListener()}}},selfClick:!1,target:null,eventTarget:null,outsideClickListener:null,scrollHandler:null,resizeListener:null,container:null,styleElement:null,overlayEventListener:null,documentKeydownListener:null,contentResizeObserver:null,beforeUnmount:function(){this.dismissable&&this.unbindOutsideClickListener(),this.scrollHandler&&(this.scrollHandler.destroy(),this.scrollHandler=null),this.destroyStyle(),this.unbindResizeListener(),this.unbindContentResizeListener(),this.target=null,this.container&&this.autoZIndex&&S.clear(this.container),this.overlayEventListener&&(T.off(`overlay-click`,this.overlayEventListener),this.overlayEventListener=null),this.container=null},mounted:function(){this.breakpoints&&this.createStyle()},methods:{toggle:function(e,t){this.visible?this.hide():this.show(e,t)},show:function(e,t){this.visible=!0,this.eventTarget=e.currentTarget,this.target=t||e.currentTarget},hide:function(){this.visible=!1},onContentClick:function(){this.selfClick=!0},onEnter:function(e){var t=this;b(e,{position:`absolute`,top:`0`}),this.alignOverlay(),this.dismissable&&this.bindOutsideClickListener(),this.bindScrollListener(),this.bindResizeListener(),this.autoZIndex&&S.set(`overlay`,e,this.baseZIndex||this.$primevue.config.zIndex.overlay),this.overlayEventListener=function(e){t.container.contains(e.target)&&(t.selfClick=!0)},this.bindContentResizeListener(),this.focus(),T.on(`overlay-click`,this.overlayEventListener),this.$emit(`show`),this.closeOnEscape&&this.bindDocumentKeyDownListener()},onLeave:function(){this.unbindOutsideClickListener(),this.unbindScrollListener(),this.unbindResizeListener(),this.unbindDocumentKeyDownListener(),this.unbindContentResizeListener(),T.off(`overlay-click`,this.overlayEventListener),this.overlayEventListener=null,this.$emit(`hide`)},onAfterLeave:function(e){this.autoZIndex&&S.clear(e)},alignOverlay:function(){_(this.container,this.target,!1);var e=v(this.container),t=v(this.target),n=0;e.left<t.left&&(n=t.left-e.left),this.container.style.setProperty(x(`popover.arrow.left`).name,`${n}px`),e.top<t.top&&(this.container.setAttribute(`data-p-popover-flipped`,`true`),!this.isUnstyled&&p(this.container,`p-popover-flipped`))},onContentKeydown:function(e){e.code===`Escape`&&this.closeOnEscape&&(this.hide(),m(this.target))},onButtonKeydown:function(e){switch(e.code){case`ArrowDown`:case`ArrowUp`:case`ArrowLeft`:case`ArrowRight`:e.preventDefault()}},focus:function(){var e=this.container.querySelector(`[autofocus]`);e&&e.focus()},onKeyDown:function(e){e.code===`Escape`&&this.closeOnEscape&&(this.visible=!1)},bindDocumentKeyDownListener:function(){this.documentKeydownListener||(this.documentKeydownListener=this.onKeyDown.bind(this),window.document.addEventListener(`keydown`,this.documentKeydownListener))},unbindDocumentKeyDownListener:function(){this.documentKeydownListener&&(window.document.removeEventListener(`keydown`,this.documentKeydownListener),this.documentKeydownListener=null)},bindOutsideClickListener:function(){var e=this;!this.outsideClickListener&&h()&&(this.outsideClickListener=function(t){e.visible&&!e.selfClick&&!e.isTargetClicked(t)&&(e.visible=!1),e.selfClick=!1},document.addEventListener(`click`,this.outsideClickListener))},unbindOutsideClickListener:function(){this.outsideClickListener&&(document.removeEventListener(`click`,this.outsideClickListener),this.outsideClickListener=null,this.selfClick=!1)},bindScrollListener:function(){var e=this;this.scrollHandler||(this.scrollHandler=new C(this.target,function(){e.visible&&(e.visible=!1)})),this.scrollHandler.bindScrollListener()},unbindScrollListener:function(){this.scrollHandler&&this.scrollHandler.unbindScrollListener()},bindResizeListener:function(){var e=this;this.resizeListener||(this.resizeListener=function(){e.visible&&!g()&&(e.visible=!1)},window.addEventListener(`resize`,this.resizeListener))},unbindResizeListener:function(){this.resizeListener&&(window.removeEventListener(`resize`,this.resizeListener),this.resizeListener=null)},bindContentResizeListener:function(){var e=this;this.contentResizeObserver||(this.contentResizeObserver=new ResizeObserver(function(){e.visible&&e.alignOverlay()}),this.contentResizeObserver.observe(this.container))},unbindContentResizeListener:function(){this.contentResizeObserver&&(this.contentResizeObserver.disconnect(),this.contentResizeObserver=null)},isTargetClicked:function(e){return this.eventTarget&&(this.eventTarget===e.target||this.eventTarget.contains(e.target))},containerRef:function(e){this.container=e},createStyle:function(){if(!this.styleElement&&!this.isUnstyled){var e;this.styleElement=document.createElement(`style`),this.styleElement.type=`text/css`,f(this.styleElement,`nonce`,(e=this.$primevue)==null||(e=e.config)==null||(e=e.csp)==null?void 0:e.nonce),document.head.appendChild(this.styleElement);var t=``;for(var n in this.breakpoints)t+=`
                        @media screen and (max-width: ${n}) {
                            .p-popover[${this.$attrSelector}] {
                                width: ${this.breakpoints[n]} !important;
                            }
                        }
                    `;this.styleElement.innerHTML=t}},destroyStyle:function(){this.styleElement&&(document.head.removeChild(this.styleElement),this.styleElement=null)},onOverlayClick:function(e){T.emit(`overlay-click`,{originalEvent:e,target:this.target})}},directives:{focustrap:O,ripple:D},components:{Portal:E}},j=[`aria-modal`];function M(f,p,m,h,g,_){var v=n(`Portal`),y=e(`focustrap`);return o(),c(v,{appendTo:f.appendTo},{default:s(function(){return[t(d,a({name:`p-anchored-overlay`,onEnter:_.onEnter,onLeave:_.onLeave,onAfterLeave:_.onAfterLeave},f.ptm(`transition`)),{default:s(function(){return[g.visible?r((o(),i(`div`,a({key:0,ref:_.containerRef,role:`dialog`,"aria-modal":g.visible,onClick:p[3]||(p[3]=function(){return _.onOverlayClick&&_.onOverlayClick.apply(_,arguments)}),class:f.cx(`root`)},f.ptmi(`root`)),[f.$slots.container?l(f.$slots,`container`,{key:0,closeCallback:_.hide,keydownCallback:function(e){return _.onButtonKeydown(e)}}):(o(),i(`div`,a({key:1,class:f.cx(`content`),onClick:p[0]||(p[0]=function(){return _.onContentClick&&_.onContentClick.apply(_,arguments)}),onMousedown:p[1]||(p[1]=function(){return _.onContentClick&&_.onContentClick.apply(_,arguments)}),onKeydown:p[2]||(p[2]=function(){return _.onContentKeydown&&_.onContentKeydown.apply(_,arguments)})},f.ptm(`content`)),[l(f.$slots,`default`)],16))],16,j)),[[y]]):u(``,!0)]}),_:3},16,[`onEnter`,`onLeave`,`onAfterLeave`])]}),_:3},8,[`appendTo`])}A.render=M;export{A as t};