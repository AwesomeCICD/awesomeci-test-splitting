<?php
use PHPUnit\Framework\TestCase;
use Demo\File92;

class File92Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File92::add(2, 3));
    }
}
