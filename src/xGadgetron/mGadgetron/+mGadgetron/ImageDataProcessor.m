classdef ImageDataProcessor < mGadgetron.GadgetChain
% Class for a chain of gadgets that has ImageData on input and output.

% CCP PETMR Synergistic Image Reconstruction Framework (SIRF).
% Copyright 2015 - 2017 Rutherford Appleton Laboratory STFC.
% 
% This is software developed for the Collaborative Computational
% Project in Positron Emission Tomography and Magnetic Resonance imaging
% (http://www.ccppetmr.ac.uk/).
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% http://www.apache.org/licenses/LICENSE-2.0
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.

    properties
        input_
        output_
    end
    methods
        function self = ImageDataProcessor(list)
%         Creates an image processor chain defined by an optional argument,
%         a Matlab cell array of gadget descriptions, each description 
%         being a Matlab string of the form
%             '[label:]gadget_name[(property1=value1[,...])]'
%         (square brackets embrace optional items, ... stands for etc.)
%         If no argument is present, the empty chain is created.
%         The use of labels enables subsequent setting of gadget properties 
%         using set_gadget_property(label, property, value).
            self.name_ = 'ImageDataProcessor';
            self.handle_ = calllib...
                ('mgadgetron', 'mGT_newObject', 'ImagesProcessor');
            mUtilities.check_status(self.name_, self.handle_);
            if nargin > 0
                for i = 1 : size(list, 2)
                    [label, name] = mUtilities.label_and_name(list{i});
                    self.add_gadget(label, mGadgetron.Gadget(name));
                end
            end
            self.input_ = [];
            self.output_ = [];
        end
        function delete(self)
            if ~isempty(self.handle_)
                mUtilities.delete(self.handle_)
                self.handle_ = [];
                %calllib('mutilities', 'mDeleteObject', self.handle_)
            end
        end
        function set_input(self, input)
%***SIRF*** Sets the input data.
            assert(isa(input, 'mGadgetron.ImageData')
            self.input_ = input;
        end
        function image = process(self, input_data)
%***SIRF*** Returns the output from the chain for the specified input.
%         Input is specified either by calling set_input or as an argument.
%         Both the input and the output are of type ImageData.
            if nargin > 1 % input is supplied as an argument
                self.set_input(input_data)
            end
            if isempty(self.input_)
                error('ImageDataProcessor:input', 'input not set')
            end
            mUtilities.assert_validity(self.input_, 'mGadgetron.ImageData')
            image = mGadgetron.ImageData();
            image.handle_ = calllib...
                ('mgadgetron', 'mGT_processImages', ...
                self.handle_, self.input_.handle_);
%                 self.handle_, input_data.handle_);
            mUtilities.check_status(self.name_, image.handle_);
            self.output_ = image;
        end
        function output = get_output(self)
%***SIRF*** Returns the processed data.
            output = self.output_;
        end
%         function apply(self, image) % cannot be done this way
%             processed_image = self.process(image);
%             calllib('mutilities', 'mDeleteObject', image.handle_)
%             image.handle_ = processed_image.handle_;
%         end
    end
end